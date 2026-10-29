# Local Jenkins controller for Akenzhan Assanali (JDK 17 + Docker CLI + pipeline plugins)
FROM jenkins/jenkins:lts-jdk17

USER root
COPY --from=docker:cli /usr/local/bin/docker /usr/local/bin/docker
USER jenkins

RUN jenkins-plugin-cli --plugins \
    workflow-aggregator git junit credentials credentials-binding \
    configuration-as-code job-dsl

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
    CASC_JENKINS_CONFIG=/usr/share/jenkins/ref/casc.yaml
COPY casc.yaml /usr/share/jenkins/ref/casc.yaml
