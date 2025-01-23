# Step 1: Use the official Jenkins LTS image as a base image
FROM jenkins/jenkins:lts

# Step 2: Set the user to root to install additional dependencies
USER root

# Step 3: Install necessary dependencies (if needed)
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Step 4: Install Docker (optional, if you need to use Docker in Jenkins)
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    usermod -aG docker jenkins && \
    rm get-docker.sh

# Step 5: Set the user back to Jenkins (default user)
USER jenkins

# Step 6: Expose necessary ports (Jenkins UI and agent communication)
EXPOSE 8080
EXPOSE 50000

# Step 7: Set environment variables (optional)
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"  # Skip setup wizard

# Step 8: Copy any custom configuration files or Jenkins plugins (optional)
# COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Step 9: Start Jenkins (this is the default entry point in the jenkins image)
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
