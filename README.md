[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/open-ortho/ortho-tank">
    <img src="https://raw.githubusercontent.com/open-ortho/ortho-tank/master/images/open-ortho.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">ortho-tank 0.1.3</h3>

  <p align="center">
    Documentation and scripts to simplify the installation and maintenance of an Orthanc based PACS Imaging Server for the orthodontic practice.
    <br />
    <a href="http://www.open-ortho.org/ortho-tank/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/open-ortho/ortho-tank/issues">Report Bug</a>
    ·
    <a href="https://github.com/open-ortho/ortho-tank/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->
- [About The Project](#about-the-project)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)


<!-- ABOUT THE PROJECT -->
## About The Project

As more and more devices adopt and implement the ability to upload or download
images in DICOM over the network, it is becoming possible for the orthodontic
practice to gain full control over their patients data: all that is missing is a
place to put and get all these images. That's where DICOM imaging server (PACS)
come in to play. 

It would be advantageous for every orthodontic practice to have a
access to a DICOM PACS. Unfortunately, most commercial solutions are designed
for large institutions and frequently not affordable for smaller orthodontic
practices.

The purpose of this project is to provide:

1) a low cost way to set up a DICOM imaging server in the orthodontic practice;
2) demonstrate that a large and expensive DICOM PACS server is not required for
smaller medical practices (like the orthodontic one).

It is really not that hard to set up a DICOM PACS server, and it also doesn't
require a lot of hardware resources. There are, however, quite a few steps
involved, and then there is maintenance. We want to simplify this as much as
possible, and show anyone interest how to do it. Only with widespread adoption
of DICOM servers will full and open interoperability become a reality

What you will find here:

* documentation for setting up an imaging server using the open source Orthanc
  PACS server, a PostgreSQL database and an NGINX server, all in docker
  containers.
* scripts and other tools for maintaining the services.


You may suggest changes by forking this repo and creating a pull request or
opening an issue. Thanks to all the people have have contributed to this
project!

A list of commonly used resources that we find helpful are listed in the
acknowledgements.

### Built With

* [Orthanc](https://www.orthanc-server.com/)
* [PostgreSQL](https://www.postgresql.org/)
* [Docker](https://www.docker.com)
* [nginx](https://nginx.org/)

<!-- GETTING STARTED -->
## Getting Started

There currently is not yet a fully released version. Released version will be in
the `main` branch. You can however find work in progress code in `develop`
branch. Documentation is in the `gh-pages` branch, and is accessible
[here](https://www.open-ortho.org/ortho-tank/).

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/open-ortho/ortho-tank/issues) for a list of proposed features (and known issues).

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a [Pull Request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request)

<!-- LICENSE -->
## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

<!-- CONTACT -->
## Contact

Toni Magni- [@zgypa](https://twitter.com/zgypa) - open-ortho@afm.co

Project Link: [https://github.com/open-ortho/ortho-tank](https://github.com/open-ortho/ortho-tank)

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

- [DICOM](https://www.webpagefx.com/tools/emoji-cheat-sheet)
- [American Dental Association Standards Committee for Dental Informatics](https://www.ada.org/en/science-research/dental-standards/standards-committee-on-dental-informatics)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/open-ortho/ortho-tank.svg?style=for-the-badge
[contributors-url]: https://github.com/open-ortho/ortho-tank/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/open-ortho/ortho-tank.svg?style=for-the-badge
[forks-url]: https://github.com/open-ortho/ortho-tank/network/members
[stars-shield]: https://img.shields.io/github/stars/open-ortho/ortho-tank.svg?style=for-the-badge
[stars-url]: https://github.com/open-ortho/ortho-tank/stargazers
[issues-shield]: https://img.shields.io/github/issues/open-ortho/ortho-tank.svg?style=for-the-badge
[issues-url]: https://github.com/open-ortho/ortho-tank/issues
[license-shield]: https://img.shields.io/github/license/open-ortho/ortho-tank.svg?style=for-the-badge
[license-url]: https://github.com/open-ortho/ortho-tank/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/open-ortho
[product-screenshot]: images/screenshot.png
[example-csv-url]: resources/example/input_from.csv
