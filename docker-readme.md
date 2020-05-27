# Lasertime Server Docker 🐳
### [GitHub Repo](https://github.com/ntflix/Lasertime-API)

## Use
This is the RESTful API layer between the [MySQL Server](https://github.com/ntflix/Lasertime-API/tree/master/SQL%20Server%20Setup) and the client using the Lasertime service. It is simply [this](https://github.com/ntflix/Lasertime-API) packaged up into one lil container for you if you don't want to get your hands dirty with Swift :)

## Example usage
```sh
docker run -d -p8080:8080 -e DATABASE_HOST="dev" -e DATABASE_PASSWORD="epicpassword123" fozflow/lasertime:1.0
```

## Environment variables 🌈
The default values are OK to use if you use the MySQL Docker configuration in the "`/SQL Server Setup`" folder of [the Lasertime Server repo](https://github.com/ntflix/Lasertime-API). Well, all apart from the hostname, of course, unless you deploy it on a machine with the hostname `hostname`, in which case no changes at all to the environmental vars are required!

Name | Description | Example | Default value
--- | --- | --- | ---
`DATABASE_HOST` | The hostname or IP address of the MySQL server to connect to | `172.16.55.241` | `hostname`
`DATABASE_USERNAME` | Username of the MySQL user | `gary` | `root`
`DATABASE_PASSWORD` | Password for said user | `mmmm cheese on toast` | `password`
`DATABASE_NAME` | Name of the database for lasertime | `worm_on_a_string` | `laser`