# San Andreas Lite - Custom-Framework

SALRP is a new FiveM community project, creating a new roleplay framework with a variety of opportunities available. The framework will be entirely custom and easy to configure. Potentially this will become an open source project if there is enough interest!

# Planned Features

- A dedicated voice chat system with a phone system.
- Whitelisted jobs such as Police and EMS.
- Non-whitelisted jobs, including pilot job, trucker, taxi, garbage collector, takeaway business etc.
- Business system with the ability to buy and sell businesses.
- Custom cars and dealerships.
- Illegal activities, found through RP.
- Buy, rent and sell properties.
- Court system to fight cases.
- Injury system with diseases and realistic ped damage.
- ... and more!

# How Long Will It Take To Be Fully Released?

This is a side project developed by myself which will only be worked on in small chunks.  
As I am currently working full time and have university commitments, this will only be worked on when I have time and won't be a rushed project.  
Depending on if we get a developer team for the future, this could take a while to become a playable framework.  
  
All work will be documented in [Discord](https://discord.gg/NMSSdWj) with a changelog and regular screenshots of the resources in action.

# Can I Help?

Officially, it is just me working on the project for now. However, people can contribute to the github by submitting PRs if they wish.  
Official devs positions will be available once the base of the framework is complete.  
You can also submit issues via the GH Repo.

# Installation
- [Setup a Server](https://docs.fivem.net/docs/server-manual/setting-up-a-server)
- EssentialMode ([Setup](https://docs.kanersps.pw/docs/essentialmode/installation))
- esplugin_mysql ([Setup](https://github.com/kanersps/esplugin_mysql/))
- MySQL-Async ([Setup](https://docs.kanersps.pw/docs/essentialmode/database))
- Place repo folders into `cfx-server-data->resources` folder
- Import SQL Files from the Repo - [SQL_1](https://github.com/ThomasPritchard/San-Andreas-Lite---Custom-Framework/blob/master/esplugin_mysql/esplugin_mysql.sql), [SQL_2](https://github.com/ThomasPritchard/San-Andreas-Lite---Custom-Framework/blob/master/SAL_Characters/character.sql)
- Configure server.cfg
```cfg
# Edit mysql_connection_string to your Database
set mysql_connection_string "server=localhost;database=essentialmode;userid=root;"

start mysql-async
start essentialmode
start esplugin_mysql
start es_admin2
start SAL_Characters
```
