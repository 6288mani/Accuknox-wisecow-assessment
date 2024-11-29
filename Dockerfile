FROM ubuntu:latest

# Install required packages: fortune, cowsay, netcat, git, bash, and coreutils (for sleep)
RUN apt-get update -y && \
    apt-get install -y fortune-mod cowsay netcat-traditional netcat-openbsd git bash coreutils && \
    git clone https://github.com/6288mani/wisecow.git /app/wisecow && \
    chmod 755 /app/wisecow/wisecow.sh && \
    echo '#!/bin/bash\nexport PATH=$PATH:/usr/games:/usr/bin\nsleep 5\n/app/wisecow/wisecow.sh' > /app/script.sh && \
    chmod +x /app/script.sh && \
    rm -rf /var/lib/apt/lists/*

# Set the environment variable for PATH
ENV PATH=$PATH:/usr/games:/usr/bin

# Expose the necessary port
EXPOSE 4499

# Run the script as the container entrypoint
CMD ["/app/script.sh"]
