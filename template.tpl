___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "TermsFeed Cookie Consent (4.1)",
  "categories": [
    "TAG_MANAGEMENT",
    "UTILITY"
  ],
  "brand": {
    "id": "termsfeed_cookie_consent_4_1",
    "displayName": "TermsFeed Cookie Consent (4.1)",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAUVBMVEUaVKkpX68rYa8yZrI0Z7M7bbVXgsBnjsZojsZzlsp1mMuHpdKJp9OKqNOWsdiXsdiYstidttqnvd6sweC8zebB0ejg6PTh6fT5+v39/v7////h+4i/AAAAAWJLR0QadWfkMgAAAGFJREFUSMdjYBgFo2AoAmEpHIAHhwZRXBoEh5gGbkYUIERQAzuqGO8g0MCJKsZHUIOEGBBwgLjcQIa4JHHBygXi8pMQD6MaqKhBBJcGARwaWNhggBnEZYVzmUbLu1EwGAAAtPMnQitCqewAAAAASUVORK5CYII\u003d"
  },
  "description": "Integrates TermsFeed Cookie Consent (4.1) notice banner and enables Google Consent Mode V2. More information at https://www.termsfeed.com/cookie-consent/",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "website_name",
    "displayName": "Your website name",
    "simpleValueType": true
  },
  {
    "type": "RADIO",
    "name": "notice_banner_type",
    "displayName": "Choose your notice banner style",
    "radioItems": [
      {
        "value": "simple",
        "displayValue": "Simple dialog"
      },
      {
        "value": "headline",
        "displayValue": "Headline dialog"
      },
      {
        "value": "interstitial",
        "displayValue": "Interstitial dialog"
      },
      {
        "value": "standalone",
        "displayValue": "Interstitial standalone"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "RADIO",
    "name": "palette",
    "displayName": "Choose a color palette",
    "radioItems": [
      {
        "value": "light",
        "displayValue": "Light"
      },
      {
        "value": "dark",
        "displayValue": "Dark"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "SELECT",
    "name": "language",
    "displayName": "Choose your default language",
    "selectItems": [
      {
        "value": "en",
        "displayValue": "English"
      },
      {
        "value": "en_gb",
        "displayValue": "English (UK)"
      },
      {
        "value": "de",
        "displayValue": "German"
      },
      {
        "value": "fr",
        "displayValue": "French"
      },
      {
        "value": "es",
        "displayValue": "Spanish"
      },
      {
        "value": "ca_es",
        "displayValue": "Catalan"
      },
      {
        "value": "it",
        "displayValue": "Italian"
      },
      {
        "value": "sv",
        "displayValue": "Swedish"
      },
      {
        "value": "no",
        "displayValue": "Norwegian"
      },
      {
        "value": "nl",
        "displayValue": "Dutch"
      }
    ],
    "defaultValue": "en",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require('logToConsole');
const getCookieValues = require('getCookieValues');
const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const decodeUriComponent = require('decodeUriComponent');
const JSON = require('JSON');
const Object = require('Object');
const injectScript = require('injectScript');
const queryPermission = require('queryPermission');
const callInWindow = require('callInWindow');
const setInWindow = require('setInWindow');
const termsfeedCookieConsentLevels = 'cookie_consent_level';

let consentSettings = {
    ad_storage: 'denied',
    ad_user_data: 'denied',
    ad_personalization: 'denied',
    analytics_storage: 'denied'
};

setInWindow('callback_user_consent_saved', function() {
  log('callback_user_consent_saved');
  initConsentFromCookie();
});

function denyAllLevels() {
    setDefaultConsentState({
        ad_storage: 'denied',
        ad_user_data: 'denied',
        ad_personalization: 'denied',
        analytics_storage: 'denied',
        wait_for_update: 500
    });
}

function initConsentFromCookie() {
    const cookie = getCookieValues(termsfeedCookieConsentLevels)[0];

    if (!cookie) {
        denyAllLevels();
        return;
    }

    const cookieObject = JSON.parse(cookie);
    const consentStatus = cookieObject.targeting ? 'granted' : 'denied';

    consentSettings = {
        analytics_storage: cookieObject.tracking ? 'granted' : 'denied',
        ad_storage: consentStatus,
        ad_user_data: consentStatus,
        ad_personalization: consentStatus,
    };

    updateConsentState(consentSettings);

}

function initCookieConsent() {
    callInWindow('cookieconsent.run', {
        "notice_banner_type": data.notice_banner_type,
        "consent_type": "express",
        "palette": data.palette,
        "language": data.language,
        "page_load_consent_levels": ["strictly-necessary"],
        "notice_banner_reject_button_hide": false,
        "preferences_center_close_button_hide": false,
        "page_refresh_confirmation_buttons": false,
        "callbacks": {
            "user_consent_saved": "callback_user_consent_saved"
        },
        "callbacks_force": true
    });
}

let url = 'https://www.termsfeed.com/public/cookie-consent/4.1.0/cookie-consent.js';
if (queryPermission('inject_script', url)) {
    initConsentFromCookie();
    injectScript(url, initCookieConsent, data.gtmOnFailure);
    data.gtmOnSuccess();
} else {
    data.gtmOnFailure();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "cookie_consent_level"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://www.termsfeed.com/public/cookie-consent/4.1.0/cookie-consent.js"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "cookieconsent"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "cookieconsent.run"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "callback_user_consent_saved"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2/21/2024, 1:15:04 PM


