#!/bin/sh

sudo yum -y install git
sudo yum -y install java-1.6.0-openjdk-devel
sudo yum -y install tomcat6-webapps
sudo yum -y install mysql
sudo yum -y install mysql-server
sudo yum -y install ant

curl http://mirror.netcologne.de/apache.org//maven/binaries/apache-maven-3.0.3-bin.zip > maven.zip
unzip maven.zip
export MAVEN_HOME=/home/tester/maven
export M2_HOME=/home/tester/maven
export PATH=$M2_HOME/bin:$PATH

export TOMCAT_HOME=/usr/share/tomcat6


git clone git://github.com/joergviola/tagbrowser.git
cd tagbrowser
ant
cd 

sudo service mysqld start
mysqladmin -u root create tagsobe
mysql -u root tagsobe -e "grant usage on *.* to tagsobe@localhost identified by 'tagsobe'"
mysql -u root tagsobe -e "grant all privileges on tagsobe.* to tagsobe@localhost"
#mysql -u tagsobe -ptagsobe tagsobe < tagsobe.sql 


git clone git://github.com/martailsauvette/tapestry5-hotel-booking.git
cd tapestry5-hotel-booking
mvn install -Dmaven.test.skip=true

sudo cp target/tapestry5-hotel-booking.war $TOMCAT_HOME/webapps/

sudo service tomcat6 start

sleep 10

echo "http://localhost:8080/tapestry5-hotel-booking/signin" > probe.url

cd ~/tagbrowser/dist
java -jar tagbrowser.jar 






