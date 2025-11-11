document.addEventListener('DOMContentLoaded', function () {
    function handleAutoLogin() {
        // Retrieve JWT token from the URL parameters
        const jwtToken = new URLSearchParams(window.location.search).get('token');

        if (jwtToken) {
            fetch('/wp-admin/admin-ajax.php?action=custom_jwt_auto_login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({ jwt_token: jwtToken })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Redirect to the provided URL or the my-account page after successful login
                        window.location.href = data.redirect ? data.redirect : '/my-account';
                    } else {
                        console.error('Login failed:', data.data);
                    }
                })
                .catch(error => {
                    console.error('Error during auto-login:', error);
                });
        }
    }

    // Initiate auto-login if the token is available in the URL
    handleAutoLogin();
});
