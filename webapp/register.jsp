<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <link rel="stylesheet" href="bootstrap.min.css">
</head>
<body class="container mt-5">

<h3>User Registration</h3>

<form action="register" method="post">

    <input class="form-control mb-2" name="username" placeholder="Username" required>

    <input class="form-control mb-2" type="password"
           name="password" placeholder="Password" required>

    <select class="form-control mb-3" name="role">
        <option value="Admin">Admin</option>
        <option value="Receptionist">Receptionist</option>
    </select>

    <button class="btn btn-success">Register</button>
</form>

<a href="login.jsp">Back to Login</a>

</body>
</html>
