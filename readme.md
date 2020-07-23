# Lasertime 📄
### RESTful API to log and access laser time for users of the Space 🛠

## API Reference
### Full API Documentation is [here](https://docs.api.lasertime.iron59.co.uk).
The Lasertime API is organized around [REST](https://en.wikipedia.org/wiki/Representational_State_Transfer).
The API accepts JSON, multipart, and XML request bodies, returns JSON response bodies, and uses standard [HTTP response codes](https://httpstatuses.com) and authentication.

The order of parameters in request bodies is not important.

### Base URL
```http
https://api.lasertime.iron59.co.uk
```
The API may only be used with TLS.

# Deploying to Docker 🐳

## Example usage
```sh
docker run -d -p8080:8080 -e DATABASE_HOST="dev" -e DATABASE_PASSWORD="epicpassword123" fozflow/lasertime:latest
```

## Environment variables 🌈
The default values are OK to use if you use the MySQL Docker configuration in the "`/SQL Server Setup`" folder of [the Lasertime Server repo](https://github.com/ntflix/Lasertime-API). Well, all apart from the hostname, of course, unless you deploy it on a machine with the hostname `hostname`, in which case no changes at all to the environmental vars are required!

Name | Description | Example | Default value
--- | --- | --- | ---
`DATABASE_HOST` | The hostname or IP address of the MySQL server to connect to | `172.16.55.241` | `hostname`
`DATABASE_USERNAME` | Username of the MySQL user | `gary` | `root`
`DATABASE_PASSWORD` | Password for said user | `mmmm cheese on toast` | `password`
`DATABASE_NAME` | Name of the database for lasertime | `worm_on_a_string` | `laser`


# Why Swift? 👀
* Fast growing, hugely popular language 😍
* Backed by Apple and open sourced 🔓
* Modern 🎂
* Ultra safe ⛑
* Super fast 🏎
* You can also use emojis as variable names (lol):
```swift
let 🧃 = "apple juice 🥰"
print("I love " + 🧃)
```
Output:
```
I love apple juice 🥰
```
