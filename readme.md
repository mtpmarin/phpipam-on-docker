# ![My Skills](https://skillicons.dev/icons?i=docker) Phpipam ready to use on Docker

![Docker](https://img.shields.io/badge/docker-%235835CC.svg?style=for-the-badge&logo=docker&logoColor=white)


Just improving my older projects.
Ready to use [phpipam](https://github.com/phpipam/phpipam) on Docker with database.

1. Rename [.env.sample](./.env.sample) to .env
2. Alter the values inside
3. Run on docker
    ```bash
    docker compose up -d
    ```
4. Access [localhost:8001](http:\\localhost:8001) and proceed with the installation


## Version of PhpIpam

You can change the version of phpipam using a "--build-arg PHPIPAM_VERSION=1.x". Just make sure that config.docker.php exists on the repo.

```bash
docker compose up -d --build-arg PHPIPAM_VERSION=1.5
```

