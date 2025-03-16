ok, i have http server that can handle login and register request from client. on login, the server sends access token in body. app stores it in memory, and will be avaialble for all the time of the life of the app. same thing with register. server also supplies the client with refresh token in a cookie

i am now wondering what when the client app is closed (killed, terminated), and then evertnutally started again after some time.

what kind of request should the client app submit (assume that server has it implemented) in order to try to login

-------

what do you think of this flow (dont approve it if it is not good, please)

the server has endpoint to get authenticated user - get-auth-user -- this endpoint expects one thing - access token in authorization header -- if this token is not there, request fails with 401 -- if it is present, it will return authenticated user

the client, on app start (either mobile or weB) makes request to the above endpoint -- it includes access token, which can either exist or not exist -- if it receives resposne of 401 to this request, it will make another request to refresh token endpoint, and once it receives that response, it will store access token to memory, and resend that get-auth-user request again.

what do you think of it? can you list pros and cons, and potential improvemnts if you think it is ok

-----

Your proposed flow is a valid approach and can work well for both web and mobile applications. Here are the pros and cons, along with potential improvements:

Pros
Unified Flow: The flow is consistent for both web and mobile clients, making it easier to maintain and understand.
Security: By requiring the access token in the authorization header, you ensure that only authenticated requests can access the user data.
Token Refresh: The client can handle expired access tokens by refreshing them, reducing the need for users to log in frequently.
Simplicity: The flow is straightforward and easy to implement.
Cons
Initial Delay: On app start, there might be a slight delay due to the need to make two requests (one to get-auth-user and another to refresh the token if needed).
Dependency on Refresh Token: If the refresh token is expired or invalid, the user will need to log in again, which might be inconvenient.
Network Overhead: Making multiple requests on app start can increase network overhead, especially if the app is frequently restarted.
Potential Improvements
Token Expiry Check: Before making the get-auth-user request, the client can check if the access token is expired. If it is, the client can directly make the refresh token request, reducing the number of requests.
Retry Mechanism: Implement a retry mechanism for the get-auth-user request after refreshing the token to handle potential race conditions or network issues.
Error Handling: Improve error handling to gracefully handle scenarios where both the access token and refresh token are invalid, prompting the user to log in again.
Caching: Implement caching mechanisms to reduce the need for frequent network requests, especially for static user data that doesn't change often.
Example Flow
App Start:

Check if access token exists and is not expired.
If access token is valid, make get-auth-user request.
If access token is missing or expired, make refresh token request.
Refresh Token Request:

If refresh token request is successful, store new access token and make get-auth-user request.
If refresh token request fails, prompt user to log in again.