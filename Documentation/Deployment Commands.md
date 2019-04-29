# Deployment Steps:-
Commands to git pull:
- git status
- git checkout .
- git pull


Commands to follow after git pull:
- mvn clean package -DskipTests-True
- sudo chmod 500 target/66days-0.0.1-SNAPSHOT.jar
- sudo chown user-nkQ68o:user-nkQ68o target/66days-0.0.1-SNAPSHOT.jar
- sudo service nginx restart



------------------------------------------------------------------------------------------
Commands to deploy:
- tux a 	( ctrl b + d )
- tail -f /var/log/nginx/access.log
- sudo -u user-nkQ68o java -jar /home/ubuntu/66-Days/target/66days-0.0.1-SNAPSHOT.jar


Commands to git push:
- git status
- git add filename
- git checkout .
- git commit -m "changes made from VM"
- git push
