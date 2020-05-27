# Lasertime 📄
### RESTful API to log and access laser time for users of the Space 🛠

## Contents
* [Authentication 🔐](#Authentication-🔐)
* [Creating a user 👩‍💻](#Creating-a-user-👩‍💻)
* [Adding a Lasertime entry ⏱](#Adding-a-Lasertime-entry-⏱)

## API Reference
The Lasertime API is organized around [REST](https://en.wikipedia.org/wiki/Representational_State_Transfer).
The API accepts JSON, multipart, and XML request bodies, returns JSON response bodies, and uses standard [HTTP response codes](https://httpstatuses.com) and authentication.

The order of parameters in request bodies is not important.

### Base URL
```http
https://api.lasertime.iron59.co.uk
```
The API may only be used with TLS.

# Authentication 🔐
The Lasertime API supports [HTTP Basic authentication](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication). This is because the amount of requests a user will be making is so small, that having JWT or sessions implemented simply wouldn't be worth the one request they would authenticate for.

>For every operation on the API using your account, such as [uploading a lasertime log](#Adding-a-Lasertime-entry-⏱), the user ID/username will be extracted automatically from each request's basic-auth header.

You will use your Lasertime username and password for the username and password.

### The following request retrieves the user details of username `'freddy'` with password `'password'`
```bash
curl -G https://api.lasertime.iron59.co.uk/user \
    -u 'freddy:password'
```
```http
GET /user HTTP/1.1
Host: api.lasertime.iron59.co.uk
Authorization: Basic ZnJlZGR5OnBhc3N3b3Jk
Accept: */*
```

### Response
```http
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 205
connection: keep-alive
date: Mon, 18 May 2020 15:20:51 GMT
```
```json
{
	"username": "freddy",
	"email": "test@example.com",
	"firstName": "Fred",
	"lastName": "Bloggs"
}
```

# Creating a user 👩‍💻
#### User requirements
* A user's username must be unique. The server will not accept an account creation request if the username is not unique.
* A user does not have to supply an email or last name.

Creating a user for the Lasertime service is as easy as a __POST__ request. No authentication is required to create a user at this stage.

### Request
```http
POST /user HTTP/1.1
Host: api.lasertime.iron59.co.uk
Content-Type: application/json
Accept: */*
```
```json
{
    "username": "freddy",
    "email": "test@example.com",
    "firstName": "Fred",
    "password": "password",
    "lastName": "Bloggs"
}
```

### Response
```http
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 51
connection: keep-alive
date: Mon, 18 May 2020 15:03:27 GMT
```
```json
{
  "username": "freddy",
  "id": "ED5A6048-7532-41D3-87EB-C32E0157FF11"
}
```

# Lasertime entries ⏱
### Required Fields

Parameter name | Description | Data type | Example
--- | --- | --- | ----
**duration** | How long the laser was on for in seconds | `Int` | `42`

### Optional Fields

Parameter name | Description | Data type | Example | Default value
--- | --- | --- | --- | ---
**descript** | Some text describing what the cut was for | `String` | `"Cutting up some pizza"` | `nil`
**cutTime** | The ISO8601 formatted date/time at which the cut started | `String` | `"2020-05-27T13:46:00+00:00"` | Current date/time
**paid** | The ISO8601 formatted date/time at which the user paid for their lasertime | `String` | `"2020-02-24T11:21:00+00:00"` | `nil`

### Request
```http
POST /lasertime HTTP/1.1
Host: api.lasertime.iron59.co.uk
Content-Type: application/json
Accept: */*
```
```json
{
    "duration": 2319,
    "descript": "Doing a bit of ply for my new pirate ship"
}
```

### Response
```json
{
  "cutTime": "2020-05-27 12:49:00 +0000",
  "userID": "AAF02299-97C4-4D87-B638-8F5BBAC57400",
  "descript": "Doing a bit of ply for my new pirate ship",
  "paid": "false"
}
```

# TODO 🗒
- [ ] Allow updates to laser log