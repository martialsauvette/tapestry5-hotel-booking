#!/bin/sh


sudo yum -y install git
sudo yum -y install java-1.6.0-openjdk-devel
sudo yum -y install tomcat6-webapps
sudo yum -y install mysql
sudo yum -y install mysql-server
sudo yum -y install ant


git clone git://github.com/martailsauvette/tagbrowser.git
cd tagbrowser
ant
cd

sudo service mysqld start
mysqladmin -u root create tagsobe
mysql -u root tagsobe -e "grant usage on *.* to tagsobe@localhost identified by 'tagsobe'"
mysql -u root tagsobe -e "grant all privileges on tagsobe.* to tagsobe@localhost"
#mysql -u tagsobe -ptagsobe tagsobe < tagsobe.sql

curl http://mirror.netcologne.de/apache.org//maven/binaries/apache-maven-3.0.4-bin.zip >maven.zip
unzip maven.zip

export MAVEN_HOME=~/apache-maven-3.0.4
export M2_HOME=~/apache-maven-3.0.4
export PATH="$PATH:$M2_HOME/bin"

cd
git clone git://github.com/martailsauvette/tapestry5-hotel-booking.git

cd
cd tapestry5-hotel-booking
mvn install -Dmaven.test.skip=true

export TOMCAT_HOME=/usr/share/tomcat6

sudo cp target/tapestry5-hotel-booking.war $TOMCAT_HOME/webapps/

sudo service tomcat6 start

sleep 10

cd
mkdir log
touch ~/log/run.log

cd ~/tagbrowser/dist
java -jar tagsobe.jar http://localhost:8080/tapestry5-hotel-booking/signin | tee ~/log/run.log

sudo service tomcat6 stop

mail -s "tagsobe result" sauvette@objectcode.de,viola@objectcode.de <  ~/log/run.log


cd

