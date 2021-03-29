FROM node:alpine3.10 AS builder

RUN mkdir /home/app
COPY . /home/app
WORKDIR /home/app
RUN npm install
RUN npm run build

FROM nginx:latest
RUN rm /usr/share/nginx/html/*
RUN rm /etc/nginx/conf.d/default.conf
#RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/bkp.conf
COPY --from=builder /home/app/dist /usr/share/nginx/html
COPY nginx-conf.conf /etc/nginx/conf.d/default.conf
COPY 50x.html /usr/share/nginx/html/
WORKDIR /usr/share/nginx/html
ENV PORT 80
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


