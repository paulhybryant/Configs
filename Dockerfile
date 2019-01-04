FROM paulhybryant/arm64v8-builder
MAINTAINER yivanus yivanus@gmail.com
RUN mkdir -p /var/mindx/meteor && chmod 777 /var/mindx/meteor
RUN apt-get update && apt-get install -y git curl libcurl3
ENV HOME /var/mindx/meteor
ENV LC_ALL "C"
RUN useradd mindx
USER mindx
RUN /usr/bin/git clone --progress https://github.com/paulhybryant/meteor.git /var/mindx/meteor/.meteor
RUN /usr/bin/curl 'http://paulhybryant.myqnapcloud.com:8880/kodexplorer/index.php?user/publicLink&fid=20b0q6pr23o_V15VF6w9p5h3JjXb-cTVQ-L6JCeIsaY0-kr2-MuDqnwIVDFeLeaW5Z3zmJ1gCh9XXcfejiAf8Pt_Bz1rWzC1t0BRqXO0z1CS3kIhPVeKehsbya1nO0z26gxWcnWo0okP6UX90c0h0_OxlwLraKMG7yqjK2HU0z_DYy7MUHJX&file_name=/dev_bundle_Linux_aarch64_8.11.4.7.tar.gz' -o /var/mindx/meteor/.meteor/dev_bundle_Linux_aarch64_8.11.4.7.tar.gz
WORKDIR /var/mindx/meteor
RUN git clone --progress https://github.com/yivanus/kityminder-meteor.git
ENV PATH $PATH:$HOME/.meteor
RUN meteor create --bare /var/mindx/meteor/kityminder-meteor-demo
WORKDIR /var/mindx/meteor/kityminder-meteor-demo/
RUN meteor add blaze-html-templates && meteor npm install --save angular angular-meteor && meteor add iron:router && meteor add meteorhacks:picker && meteor add session && meteor add autopublish
WORKDIR /var/mindx/meteor/kityminder-meteor
RUN cp -r -f README.md client collection packages.json server public /var/mindx/meteor/kityminder-meteor-demo/
WORKDIR /var/mindx/meteor/kityminder-meteor-demo/

RUN meteor add meteorhacks:npm && meteor update meteorhacks:npm && meteor update --all-packages
RUN meteor remove static-html && meteor

RUN echo "#! /bin/bash" > /var/mindx/meteor/meteor.sh && echo "cd /var/mindx/meteor/kityminder-meteor-demo" >> /var/mindx/meteor/meteor.sh  && echo "meteor run -p 8899" >> /var/mindx/meteor/meteor.sh
RUN chmod +x /var/mindx/meteor/meteor.sh
RUN echo `cat /var/mindx/meteor/meteor.sh`
EXPOSE 8899
CMD "/var/mindx/meteor/meteor.sh"
