from os import environ

from flask import Flask, g, render_template, redirect, url_for
from flask_oidc import OpenIDConnect
from okta import UsersClient


app = Flask(__name__)
app.config["DEBUG"] = True
app.config["OIDC_CLIENT_SECRETS"] = "client_secrets.json"
app.config["OIDC_COOKIE_SECURE"] = False
app.config["OIDC_CALLBACK_ROUTE"] = "/oidc/callback"
app.config["OIDC_SCOPES"] = ["openid", "email", "profile"]
app.config["SECRET_KEY"] = "NuageNetworks2019!"
app.config["OIDC_ID_TOKEN_COOKIE_NAME"] = "oidc_token"
oidc = OpenIDConnect(app)
okta_client = UsersClient("https://dev-451384.okta.com/", "7A9aftq_0pgKDZXIeic8LWpXpMRa3asSf9Qpyyli")


@app.before_request
def before_request():
    """
    Load a proper user object using the user ID from the ID token. This way, the
    `g.user` object can be used at any point.
    """
    if oidc.user_loggedin:
        g.user = okta_client.get_user(oidc.user_getfield("sub"))
    else:
        g.user = None


@app.route("/")
def index():
    """
    Render the homepage.
    """
    return render_template("index.html")


@app.route("/dashboard")
@oidc.require_login
def dashboard():
    """
    Render the dashboard page.
    """
    return render_template("dashboard.html")


@app.route("/login")
@oidc.require_login
def login():
    """
    Force the user to login, then redirect them to the dashboard.
    """
    return redirect(url_for(".dashboard"))


@app.route("/logout")
def logout():
    """
    Log the user out of their account.
    """
    oidc.logout()
    return redirect(url_for(".index"))