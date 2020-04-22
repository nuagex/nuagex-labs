from os import environ

from flask import Flask, g, render_template, redirect, url_for

app = Flask(__name__)

@app.route("/")
def index():
    """
    Render the homepage.
    """
    return render_template("index.html")


@app.route("/dashboard")
def dashboard():
    """
    Render the dashboard page.
    """
    return render_template("index.html")


@app.route("/login")
def login():
    """
    Force the user to login, then redirect them to the dashboard.
    """
    return render_template("index.html")


@app.route("/logout")
def logout():
    """
    Log the user out of their account.
    """
    return redirect(url_for(".index"))

if __name__ == "__main__":
    app.run(host='0.0.0.0')
