FROM node:17

ENV LANG C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

WORKDIR /myapp
COPY --chown=app:app package.json .
COPY --chown=app:app package-lock.json .
RUN npm i

EXPOSE 3000
CMD [ "npm", "start" ]
