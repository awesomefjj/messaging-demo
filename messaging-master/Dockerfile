# ======== 运行环境 =======
FROM uhub.service.ucloud.cn/tamigosmirrors/ruby:2.5.8-alpine3.13 as runtime
LABEL maintainer="xiaohui@tanmer.com"

WORKDIR /app
RUN mkdir -p /app \
    && sed -i 's!https://dl-cdn.alpinelinux.org!https://mirrors.aliyun.com!' /etc/apk/repositories \
    && apk add tzdata postgresql-dev ruby-nokogiri ruby-ffi libxml2-dev libxslt-dev nodejs \
    && gem source --remove https://rubygems.org/ --add https://gems.ruby-china.com/ \
    && gem install bundler \
    && bundle config mirror.https://rubygems.org https://gems.ruby-china.com \
    && bundle config force_ruby_platform true \
    && bundle config set without 'development test' \
    && addgroup -S app \
    && adduser -S -G app app

# ============= 编译环境 ===============
FROM runtime as build
RUN apk add --virtual rails-build-deps \
       build-base ruby-dev libc-dev linux-headers \
       git yarn \
    && yarn config set registry http://registry.npm.taobao.org \
    && yarn config set sass-binary-site http://npm.taobao.org/mirrors/node-sass

# 安装 npm 包
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
RUN yarn

# 安装 gem 包
COPY Gemfile Gemfile.lock /app/
COPY vendor/cache /app/vendor/cache
ARG BUNDLE_GEMS__TANMER__COM
RUN BUNDLE_GEMS__TANMER__COM="${BUNDLE_GEMS__TANMER__COM}" \
      bundle config build.nokogiri --use-system-libraries \
      && bundle install -j $(nproc) --local

# 拷贝源代码
COPY .git .git

# 编译资源
RUN git checkout -- . \
    && export RELEASE_COMMIT=$(git rev-parse --short HEAD) \
    && git rev-parse --short HEAD > RELEASE_COMMIT \
    && echo $(git symbolic-ref -q --short HEAD || true) > RELEASE_BRANCH \
    && RAILS_ENV=production \
       SECRET_KEY_BASE=xxx \
       DATABASE_ADAPTER=nulldb \
       bundle exec rails assets:precompile \
    && rm -rf .git vendor/cache node_modules deploy docker\
    && chown app:app -R /app

# ======== 最终运行环境 =======
FROM runtime as rails
EXPOSE 3000
RUN rm -rf /usr/local/bundle
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app
USER app
