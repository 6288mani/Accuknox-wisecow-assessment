# Use a base image, for example, Ubuntu
FROM ubuntu:latest

# The `<<EOF ... EOF` syntax is known as a "here document" and allows you to run multiple commands in one `RUN` instruction.
#It’s used to avoid creating multiple layers and can help in managing complex build instructions
RUN <<EOF
apt-get update -y
apt-get install fortune-mod cowsay -y \
apt-get install cowsay -y
apt-get install netcat-traditional -y
apt-get install netcat-openbsd -y
apt-get install git -y
git clone https://github.com/6288mani/wisecow.git
chmod 755 ./wisecow/wisecow.sh
sleep 5
echo '#!/bin/bash\nexport PATH=$PATH:/usr/games/\nsleep 5\n./test/wisecow.sh' > script.sh
sleep 5
chmod 755 script.sh
EOF

# Expose port 4499
EXPOSE 4499

# Define the command to run the script
CMD ["./script.sh"]
