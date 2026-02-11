<form action="AdminLoginServlet" method="post">
    <h2>Admin Login</h2>

    Username:
    <input type="text" name="username" required>

    Password:
    <input type="password" name="password" required>

    <button type="submit">Login</button>

    <p style="color:red">${error}</p>
</form>
 <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f7f6; padding: 40px; }
        .container { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 800px; margin: auto; }
        h2 { color: #333; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #3498db; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f1f1f1; }
        .btn-delete { color: #e74c3c; text-decoration: none; font-weight: bold; border: 1px solid #e74c3c; padding: 5px 10px; border-radius: 4px; }
        .btn-delete:hover { background: #e74c3c; color: white; }
        .add-form { margin-bottom: 20px; padding: 15px; background: #e8f4fd; border-radius: 5px; }
    </style>