<?php

//JWT
add_action('template_redirect', function() {
	if (isset($_GET['token'])) {
	  $token = $_GET['token'];
	  $jwt_secret_key = JWT_AUTH_SECRET_KEY;
	  $decoded = JWT::decode($token, new Key($jwt_secret_key, apply_filters('jwt_auth_algorithm', 'HS256')));
  		// error_log(print_r($decoded, true));
	  if ($decoded) {
		$user = get_user_by('ID', $decoded->data->user->id);  // Use the decoded ID to fetch the user
		if ($user) {
		  wp_set_auth_cookie($user->ID, true);  // Log the user in
		  wp_redirect(home_url() . '/my-account');  // Redirect after login
		  exit;
		}
	  }
	}
});

//Reset Password
add_action('rest_api_init', function () {
    register_rest_route('custom/v1', '/reset-password', array(
        'methods' => 'POST',
        'callback' => 'custom_reset_password'
    ));
});

function custom_reset_password(WP_REST_Request $request) {
    // Get new password from the request
    $params = $request->get_json_params();
    $new_password = isset($params['new_password']) ? $params['new_password'] : '';
    $new_name = isset($params['new_name']) ? $params['new_name'] : '';

    // Ensure the new password is provided
    if (empty($new_password)) {
        return new WP_Error('missing_password', 'New password is required', array('status' => 400));
    }

    if (empty($new_name)) {
        return new WP_Error('missing_username', 'New name is required', array('status' => 400));
    }  
    // Get the currently authenticated user
    $user_id = get_current_user_id();
    if (!$user_id) {
        return new WP_Error('user_not_found', 'No user is authenticated', array('status' => 401));
    }

    // Update the user's password
    wp_set_password($new_password, $user_id);

    wp_update_user(array(
        'ID' => $user_id, // User ID to update
        'display_name' => sanitize_text_field($new_name) // New display name
    ));

    // Log the user out from other sessions
    wp_destroy_all_sessions($user_id);

    return new WP_REST_Response(array(
        'message' => 'Password has been reset successfully',
    ), 200);
}

// Send Password Reset Email API Endpoint
add_action('rest_api_init', function () {
    register_rest_route('custom/v1', '/send-password-reset', array(
        'methods' => 'POST',
        'callback' => 'send_password_reset_email',
        'permission_callback' => '__return_true', // Public endpoint, no auth required
    ));
});

function send_password_reset_email(WP_REST_Request $request) {
    // Get the email from the request
    $params = $request->get_json_params();
    $user_email = isset($params['email']) ? sanitize_email($params['email']) : '';

    // Ensure the email is provided
    if (empty($user_email)) {
        return new WP_Error('missing_email', 'Email is required', array('status' => 400));
    }

    // Check if a user exists with this email
    $user = get_user_by('email', $user_email);
    if (!$user) {
        return new WP_Error('invalid_email', 'No user found with this email address.', array('status' => 404));
    }

    // Use the built-in function to send the reset password email
    $reset = retrieve_password($user_email);
    
    // Check if the password reset email was sent successfully
    if (is_wp_error($reset)) {
        return new WP_Error('reset_failed', $reset->get_error_message(), array('status' => 500));
    }

    return rest_ensure_response(array(
        'message' => 'Password reset email has been sent.'
    ));
}







//One Time Login
add_action('rest_api_init', function () {
    register_rest_route('custom/v1', '/one-time-login', array(
        'methods' => 'POST',
        'callback' => 'generate_one_time_login_link',
        'permission_callback' => function () {
            return current_user_can('edit_posts'); // Adjust permissions as needed
        }
    ));
});

function generate_one_time_login_link(WP_REST_Request $request) {
    $user_id = $request->get_param('user_id');
    $user = get_user_by('id', $user_id);

    if (!$user) {
        return new WP_Error('no_user', 'User not found', array('status' => 404));
    }

    $token = bin2hex(random_bytes(16)); // Generate a unique token
    // Store the token in user meta or another secure location
    update_user_meta($user_id, 'one_time_login_token', $token);

    $login_link = home_url("/?token={$token}");
    return rest_ensure_response(['login_link' => $login_link]);
}
//////////////////////


function custom_jwt_decode($jwt, $secret_key) {
    // Split the JWT into header, payload, and signature
    $tks = explode('.', $jwt);
    if (count($tks) != 3) {
        throw new UnexpectedValueException('Wrong number of segments in token');
    }

    list($header64, $payload64, $signature64) = $tks;

    // Base64 decode the header and payload
    $header = json_decode(base64_decode(strtr($header64, '-_', '+/')));
    $payload = json_decode(base64_decode(strtr($payload64, '-_', '+/')));

    if (!$header || !$payload) {
        throw new UnexpectedValueException('Invalid header or payload encoding');
    }

    // Verify the signature
    $sig = base64_decode(strtr($signature64, '-_', '+/'));
    $expected_sig = hash_hmac('sha256', "$header64.$payload64", $secret_key, true);

//    if (!hash_equals($expected_sig, $sig)) {
//        throw new Exception('Signature verification failed');
//    }

    // Return the decoded payload (assuming it's valid JSON)
    return $payload;
}

function custom_jwt_auto_login() {
    if ( ! isset( $_POST['jwt_token'] ) ) {
        wp_send_json_error( 'No token provided', 400 );
        exit;
    }

    $jwt_token = sanitize_text_field( $_POST['jwt_token'] );

    // Ensure the JWT library is included only once
    // if ( ! class_exists( 'Firebase\JWT\JWT' ) ) {
    //     require_once WP_PLUGIN_DIR.'/php-jwt/src/JWT.php'; // Adjust the path as needed
    // }

    if ( ! defined('JWT_AUTH_SECRET_KEY') ) {
        wp_send_json_error( 'Secret key not defined', 500 );
        exit;
    }
    $secret_key = constant('JWT_AUTH_SECRET_KEY');

    try {
        // Decode the JWT token. Ensure the algorithm matches what was used to sign the token.
        // $decoded = Firebase\JWT\JWT::decode( $jwt_token, $secret_key, array( 'HS256' ) );
        $decoded = custom_jwt_decode( $jwt_token, $secret_key );
        // Debugging: Output the decoded token content for verification
        // error_log("Decoded JWT Payload: " . print_r($decoded, true));

        // Validate the payload
        if ( ! isset( $decoded->data->user->id ) ) {
            wp_send_json_error( 'Invalid token payload', 401 );
            exit;
        }

        $user_id = $decoded->data->user->id;
        $user_password = $decoded->data->user->password;
        $user = get_user_by( 'ID', $user_id );

        if ( ! $user ) {
            wp_send_json_error( 'User not found', 404 );
            exit;
        }

        $user_login_data = array(
            'user_login'    => $user->user_login,
            'user_password' => $user_password,
            'remember'      => true,
        );

        $user_signon = wp_signon( $user_login_data, false );

        error_log("Decoded JWT Payload: " . print_r($user_signon, true));

        // Check if the login was successful
        if ( is_wp_error( $user_signon ) ) {
            wp_send_json_error( 'Login failed: ' . $user_signon->get_error_message(), 401 );
            exit;
        }
        else {
            // Handle successful login
            // do_action( 'wp_login', $user_signon->data->user_login, $user_signon->ID );
            wp_set_current_user( $user_signon->ID );
            wp_set_auth_cookie( $user_signon->ID, true );
            wp_send_json_success( array(
                'message' => 'User logged in successfully',
                'redirect' => home_url('/my-account'), // Provide URL for redirection
            ));
            exit;
        }
    } catch ( Exception $e ) {
        // Log the exact error for debugging
        error_log('Token validation failed: ' . $e->getMessage());
        wp_send_json_error( 'Token validation failed: ' . $e->getMessage(), 401 );
        exit;
    }
}

add_action('wp_ajax_nopriv_custom_jwt_auto_login', 'custom_jwt_auto_login');
add_action('wp_ajax_custom_jwt_auto_login', 'custom_jwt_auto_login');

function enqueue_auto_login_script() {
    wp_enqueue_script(
        'auto-login-script',
        get_template_directory_uri() . '/auto-login.js', // Path to your JS file
        array(), // Dependencies
        null, // Version
        true // Load in footer
    );
}

add_action('wp_enqueue_scripts', 'enqueue_auto_login_script');



define('JWT_AUTH_SECRET_KEY', '4wqF12gUq4mLZoV7Y2T7BRzF7p5sEexD9gPxtHT6jFA');

define('WP_DEBUG', true);

define('WP_DEBUG_LOG', true);

define('WP_DEBUG_DISPLAY', false);







add_action('rest_api_init', function () {
    register_rest_route('custom/v1', '/login', array(
        'methods' => 'POST',
        'callback' => 'custom_jwt_login_handler',
        'permission_callback' => '__return_true',
    ));
});

function custom_jwt_login_handler(WP_REST_Request $request) {
    $jwt_token = $request->get_param('jwt_token');

    if (empty($jwt_token)) {
        return new WP_Error('no_token', 'No token provided', array('status' => 400));
    }

    $secret_key = defined('JWT_AUTH_SECRET_KEY') ? constant('JWT_AUTH_SECRET_KEY') : '';

    try {
        $decoded = custom_jwt_decode($jwt_token, $secret_key);

        if (!isset($decoded->data->user->id)) {
            return new WP_Error('invalid_token', 'Invalid token payload', array('status' => 401));
        }

        $user_id = $decoded->data->user->id;
        $user_password = $decoded->data->user->password;
        $user = get_user_by('ID', $user_id);

        if (!$user) {
            return new WP_Error('user_not_found', 'User not found', array('status' => 404));
        }

        $user_login_data = array(
            'user_login'    => $user->user_login,
            'user_password' => $user_password,
            'remember'      => true,
        );

        $user_signon = wp_signon($user_login_data, false);

        if (is_wp_error($user_signon)) {
            return new WP_Error('login_failed', 'Login failed: ' . $user_signon->get_error_message(), array('status' => 401));
        } else {
            wp_set_current_user($user_signon->ID);
            wp_set_auth_cookie($user_signon->ID, true);

            return array(
                'message' => 'User logged in successfully',
                'redirect' => home_url('/my-account'),
            );
        }
    } catch (Exception $e) {
        return new WP_Error('token_validation_failed', 'Token validation failed: ' . $e->getMessage(), array('status' => 401));
    }
}
