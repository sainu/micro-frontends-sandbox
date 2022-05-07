FROM ruby:3.1.2

ENV LANG C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

WORKDIR /myapp
COPY --chown=app:app Gemfile .
COPY --chown=app:app Gemfile.lock .
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD [ "bundle", "exec", "ruby", "myapp.rb", "-p", "3000" ]
