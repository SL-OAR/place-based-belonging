# Who is SWaSI?

The [Student Wellbeing and Success Initiative](https://uoregon-my.sharepoint.com/:u:/g/personal/clark13_uoregon_edu/EY4zzGdo3o9ImgpS89tM2wAB4CrNAqmPyAxDAZQ-mNuzJw) is:

- an ongoing, multicohort, longitudinal research program designed to holistically understand institutional inputs to undergraduate students’ wellbeing and success across the college experience
- an educational program designed to equitably improve wellbeing and success outcomes, particularly among historically marginalized populations (e.g., first-generation students, Black students)
- an assessment and evaluation program designed to gauge whether various programmatic activities, including but not limited to the ones internal to the Initiative itself, are meeting their stated goals

Better understanding better informs us, affording opportunities to improve institutional practices that equitably support students’ learning and development and foster their achievement and persistence. Unlike many for-profit companies, which use data to sell people, this is a strategy that uses data to [empower](#) people.

The Student Wellbeing and Success Initiative is led by Brian Clark, Assistant Director of the [Office of Assessment and Research](https://studentlife.uoregon.edu/research) in the [Division of Student Life](https://studentlife.uoregon.edu/). It is supported primarily by the Office of the Vice President for Student Life with integral support from units of the Division of Student Life -- the [Department of Physical Education and Recreation](https://rec.uoregon.edu/), the [Erb Memorial Union](https://emu.uoregon.edu/), and the [Office of the Dean of Students](https://dos.uoregon.edu/) -- and across campus from many and varied units in [Global Engagement](https://international.uoregon.edu/), the [Office of the Provost](https://provost.uoregon.edu/), [Student Services and Enrollment Management](https://ssem.uoregon.edu/), [UO Libraries](https://library.uoregon.edu/), and [Undergraduate Education and Student Success](https://uess.uoregon.edu/).

<br>

# What is this Document for?

The purposes of this document are:

1. to conduct a comprehensive analysis of place-based belonging data
2. to provide a general reference and resource tool for higher education professionals who do things and make decisions about things that affect students (many of those things are tied to or rooted in physical places)
3. to describe the development of methods used to generate place-based belonging data

[This document is currently under construction and is in a "good enough for now" state](#){style="color: #11E8FF"}. It will be incrementally updated with subsequent data collection. 

## What is Place-Based Belonging?

Over the last several years, we have been incrementally exploring the concept of place-based belonging: the idea that people’s affinity for physical places, or lack thereof, is intertwined with their sense of whether they fit in socially. Theoretically, it is a special case of the environmental psychology concept of place attachment ([Altman & Low, 1992](https://link.springer.com/chapter/10.1007/978-1-4684-8753-4_1)), with conceptual focus on the place dimension over the person or process dimensions ([Scannell & Gifford, 2010](https://uoregon-my.sharepoint.com/:b:/g/personal/clark13_uoregon_edu/EUOwgiMvl5pKonwqByWz8BoBkjCnPQk0VAw9mm1fzn3XfQ?e=WW9q1Z)) and content focus on social meanings with which places are imbued as a subset of the general affective associations people have with places. Methodologically, it departs significantly from the psychometric approach of much place attachment research (e.g., [Williams, 2014](https://uoregon-my.sharepoint.com/:b:/g/personal/clark13_uoregon_edu/EVGZxfZPNRlEoofpQI9UQz4BreUZgn5Z-W0Z7gVMNK7fdQ?e=xTznoC); [Williams & Vaske, 2003](https://uoregon-my.sharepoint.com/:b:/g/personal/clark13_uoregon_edu/EVXdi_qf-_hPpRc_iruUoNwBJ1ma0fuw3ZHknWZWW2YAXQ?e=pVPMkt)), aligning more closely with cultural mapping. Cultural mapping is an interdisciplinary field broadly tied together by a mode of inquiry and general methodology that reckons with documenting a community's place-based features and assets for a wide range of purposes. See [Duxbury et al. (2015)](https://uoregon-my.sharepoint.com/:b:/g/personal/clark13_uoregon_edu/EQSU3UqGrw1GpScojaHKFVUBLiH2uuzMOtTlFmkpMoEr6w?e=jE9T38) for an introduction and the [whole book](https://www.routledge.com/Cultural-Mapping-as-Cultural-Inquiry/Duxbury-Garrett-Petts-MacLennan/p/book/9780367599003) for varied perspectives. Place-based belonging, specifically, has roots in humanistic and cultural geography traditions, which feed into cultural mapping, and is depicted by a kind of symbol mapping ([Soini, 2001](https://uoregon-my.sharepoint.com/:b:/g/personal/clark13_uoregon_edu/EVIw9hlo0LdGkCrxUpVFoYwBg__H3LRwrnGmUAavpQ1pRg?e=JyQV4u)).

Adapting methods from [Pitcher & Royal (2016)](https://uoregon-my.sharepoint.com/:b:/g/personal/clark13_uoregon_edu/ETDssdQ-bW1LsSA_db4aaVgBd_vO02wIffeQ_AqgQ3TgwQ?e=yBVY5o), we ask students to click up to three places on a campus map they feel like they “belong, fit in, are connected, are accepted, etc.,” and separately, to click up to three places they feel like they "[do not](#) belong, [do not](#) fit in, are [dis](#) connected, are [not](#) accepted, etc.” After clicking "belong" and "don't belong" places on a campus map, we follow up about select places to try and understand more about them. Generally, we ask students to describe in text why they feel the ways they do about the places. A unique aspect of follow-up involves delving into the Erb Memorial Union (EMU), which is a compact set of places, which cannot be disaggregated given a campus map and which form a unified place we call the EMU. If a student clicks on the EMU at the campus level, we follow up with a map of the EMU and ask them to click on places within the EMU they feel like they belong and don't belong, and then ask them to describe why. (Map and follow-up methods have varied over the years of development. See [Supplemental Method](#supmeth) for more details.)

The methods above generate data that allow us to do several things:

- describe a place and rank-order multiple places in terms of belong and don't belong sentiments
- describe a place and rank-order multiple places in terms of inclusiveness, which is a combination of both belong and don't belong sentiments
- disaggregate a place's inclusiveness by demographics
- explore why places have belong or don't belong sentiments associated with them
- describe how places relate to each other through belong and don't belong sentiments

Application Notes:

- The application is created using the [**periscope**](https://github.com/neuhausi/periscope) package. Periscope was originally developed as the core Shiny component for bioinformatics and systems biology analysis applications. It provides a predefined but flexible template for new Shiny applications with a default dashboard layout, three locations for user alerts, a nice busy indicator and logging features. One of the most important features of the shiny applications created with this framework is the separation by file of functionality that exists in one of the three shiny scopes: global, server-global, and server-local. The framework forces application developers to consciously consider scoping in Shiny applications by making scoping distinctions very clear without interfering with normal application development. Scoping consideration is important for performance and scaling, which is critical when working with large datasets and/or across many users. In addition to providing a template application, the framework also contains a number of convenient modules: a (multi)file download button module and a downloadable table module for example.

*This application is developed and maintained by the externs at the Office of Assessment and Research at the University of Oregon. This is a work in progress.*

To cite, please use the following.

Much of the content of this dashboard, including the summary written above, was built on the foundation laid by Dr. Brian Clark. This dashboard was completed by the interns at the Office of Assessment and Research just before his passing. 

His devotion and support to supporting students at the university is immeasurable. We dedicate this dashboard to him.

Guha, A., Daza, T., Aragon, D., & Clark, B.A.M. (2025). University of Oregon Place-Based Belonging Dashboard. Office of Assessment and Research, Division of Student Life. University of Oregon.

