#!/usr/bin/env bash
# restart API with new data

# these can be changed but most other variables should be left alone
APP_LBL='api-endpoint'  # descriptive label for endpoint-related directories
REPO_LBL='topicmodel'  # directory where repo code will go
MODEL_WGET='https://ndownloader.figshare.com/files/<file-number>'

# derived paths
ETC_PATH="/etc/${APP_LBL}"  # app config info, scripts, ML models, etc.
TMP_PATH="/tmp/${APP_LBL}"  # store temporary files created as part of setting up app (cleared with every update)

echo "Downloading data, hang on..."
cd ${TMP_PATH}
wget -O gender_all_latest.sqlite -q ${MODEL_WGET}
mv gender_all_latest.sqlite ${ETC_PATH}/resources
chown -R www-data:www-data ${ETC_PATH}

echo "Enabling and starting services..."
systemctl enable model.service  # uwsgi starts when server starts up
systemctl daemon-reload  # refresh state

systemctl restart model.service  # start up uwsgi
systemctl restart nginx  # start up nginx