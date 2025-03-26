local sealexports = {
  seal_chat = false,
  seal_groups = false,
}
local function sealangProcessExports()
  for k in pairs(sealexports) do
    local res = getResourceFromName(k)
    if res and getResourceState(res) == "running" then
      sealexports[k] = exports[k]
    else
      sealexports[k] = false
    end
  end
end
sealangProcessExports()
if triggerServerEvent then
  addEventHandler("onClientResourceStart", getRootElement(), sealangProcessExports, true, "high+9999999999")
end
if triggerClientEvent then
  addEventHandler("onResourceStart", getRootElement(), sealangProcessExports, true, "high+9999999999")
end
local activeFakeInput = false
local usedphone = 1
local currentPage = "lockscreen"
local activeButton
local smsWithChangeOFF = 0
local Roboto = dxCreateFont("mobile/Roboto.ttf", resp(12), false, "antialiased")
local RobotoL = dxCreateFont("mobile/RobotoL.ttf", resp(40), false, "antialiased")
local RobotoB = dxCreateFont("mobile/RobotoB.ttf", resp(24), false, "antialiased")
local fakeInputValues = {}
local screenSourceX, screenSourceY = 1885, 1075
local screenSource = false
local gameBrowser = false
local phones = {
  [1] = {
    base = {
      startpos = {-135, -15},
      contents = {
        {
          "image",
          0,
          0,
          512,
          512,
          "mobile/moto-g.png"
        },
        {"wallpaper"}
      },
      buttons = {}
    },
    ["page:lockscreen"] = {
      startpos = {13, 54},
      disableHud = true,
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(0, 0, 0, 150)
        },
        {
          "dynamictext",
          "#currenttime",
          0,
          150,
          215,
          2,
          tocolor(255, 255, 255),
          1,
          RobotoL,
          "center",
          "center"
        },
        {
          "text",
          "Érintsd meg a feloldáshoz",
          0,
          0,
          215,
          357,
          tocolor(255, 255, 255),
          0.75,
          Roboto,
          "center",
          "bottom"
        },
        {
          "notifications",
          10,
          150,
          195,
          40,
          tocolor(255, 255, 255, 150)
        },
        {
          "taskbar",
          tocolor(0, 0, 0, 150)
        }
      },
      buttons = {
        {
          0,
          334.5,
          215,
          359.5,
          "unLockPhone"
        },
        {
          10,
          150,
          205,
          190,
          "notificationAction:1"
        },
        {
          10,
          195,
          205,
          235,
          "notificationAction:2"
        }
      }
    },
    ["page:home"] = {
      startpos = {13, 54},
      contents = {
        {
          "taskbar",
          tocolor(0, 0, 0, 150)
        },
        {
          "dynamictext",
          "#currenttime",
          0,
          150,
          215,
          2,
          tocolor(255, 255, 255),
          1,
          RobotoL,
          "center",
          "center"
        },
        {
          "image",
          -148,
          -69,
          512,
          512,
          "mobile/menu.png"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 200)
        }
      },
      buttons = {
        {
          8,
          307,
          42,
          343,
          "changepage:phone"
        },
        {
          48,
          307,
          78,
          343,
          "changepage:messages"
        },
        {
          92,
          307,
          122,
          343,
          "changepage:calculator"
        },
        {
          137,
          307,
          165,
          343,
          "changepage:camera"
        },
        {
          174,
          307,
          206,
          343,
          "changepage:settings"
        },
        {
          8,
          269,
          42,
          301,
          "changepage:contacts"
        },
        {
          48,
          269,
          78,
          301,
          "changepage:advertise"
        },
        {
          92,
          269,
          122,
          301,
          "seeNion"
        },
        {
          137,
          269,
          165,
          301,
          "game:hextris"
        },
        {
          174,
          269,
          206,
          301,
          "game:invaders"
        }
      }
    },
    ["page:phone"] = {
      startpos = {13, 54},
      pageFakeInput = "num-only|15|nocursor",
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(250, 250, 250, 255)
        },
        {
          "taskbar",
          tocolor(2, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          150,
          215,
          227,
          tocolor(252, 252, 252, 255)
        },
        {
          "image",
          -148,
          -69,
          512,
          512,
          "mobile/dialer.png"
        },
        {
          "dynamictext",
          "#fakeInputValue:page/phone",
          0,
          111,
          215,
          151,
          tocolor(0, 0, 0, 200),
          1,
          Roboto,
          "center",
          "center"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {
          "callHistory",
          4,
          15,
          15,
          200,
          95,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          185,
          111,
          215,
          151,
          "injectFakeInput:backspace"
        },
        {
          32,
          151,
          62,
          181,
          "injectFakeInput:1"
        },
        {
          92,
          151,
          122,
          181,
          "injectFakeInput:2"
        },
        {
          152,
          151,
          182,
          181,
          "injectFakeInput:3"
        },
        {
          32,
          187,
          62,
          217,
          "injectFakeInput:4"
        },
        {
          92,
          187,
          122,
          217,
          "injectFakeInput:5"
        },
        {
          152,
          187,
          182,
          217,
          "injectFakeInput:6"
        },
        {
          32,
          226,
          62,
          256,
          "injectFakeInput:7"
        },
        {
          92,
          226,
          122,
          256,
          "injectFakeInput:8"
        },
        {
          152,
          226,
          182,
          256,
          "injectFakeInput:9"
        },
        {
          92,
          266,
          122,
          296,
          "injectFakeInput:0"
        },
        {
          92,
          306,
          122,
          336,
          "dialNumber"
        },
        {
          185,
          15,
          215,
          38.75,
          "dialHistory:1"
        },
        {
          185,
          38.75,
          215,
          62.5,
          "dialHistory:2"
        },
        {
          185,
          62.5,
          215,
          86.25,
          "dialHistory:3"
        },
        {
          185,
          86.25,
          215,
          110,
          "dialHistory:4"
        },
        {
          165,
          15,
          185,
          38.75,
          "historyToContact:1"
        },
        {
          165,
          38.75,
          185,
          62.5,
          "historyToContact:2"
        },
        {
          165,
          62.5,
          185,
          86.25,
          "historyToContact:3"
        },
        {
          165,
          86.25,
          185,
          110,
          "historyToContact:4"
        }
      }
    },
    ["page:incomingCall"] = {
      startpos = {13, 54},
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(3, 135, 209, 255)
        },
        {
          "taskbar",
          tocolor(2, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          150,
          215,
          227,
          tocolor(25, 25, 25, 255)
        },
        {
          "incoming",
          -148,
          -69,
          512,
          512
        },
        {
          "text",
          "Bejövő hívás",
          13,
          15,
          215,
          66,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#caller",
          13,
          0,
          215,
          131,
          tocolor(255, 255, 255, 200),
          0.5,
          RobotoL,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#callNum",
          13,
          50,
          215,
          131,
          tocolor(255, 255, 255, 200),
          0.9,
          Roboto,
          "left",
          "center"
        }
      },
      buttons = {
        {
          0,
          0,
          215,
          377,
          "incomingButtonUp_[up]"
        },
        {
          88,
          233,
          128,
          271,
          "incomingButtonDown"
        },
        {
          17,
          241,
          47,
          266,
          "cancelCall_[up]_[isButtonDown]"
        },
        {
          172,
          241,
          197,
          266,
          "acceptCall_[up]_[isButtonDown]"
        }
      }
    },
    ["page:talking"] = {
      startpos = {13, 54},
      fakeInputs = {
        {
          7,
          96,
          377,
          131,
          "talkingMessage",
          "normal|23"
        }
      },
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(3, 135, 209, 255)
        },
        {
          "taskbar",
          tocolor(2, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          150,
          215,
          227,
          tocolor(25, 25, 25, 255)
        },
        {
          "image",
          -148,
          -69,
          512,
          512,
          "mobile/talking.png"
        },
        {
          "dynamictext",
          "#talkingText",
          13,
          15,
          215,
          36,
          tocolor(255, 255, 255, 200),
          0.75,
          Roboto,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#talkingToNumber",
          13,
          0,
          215,
          101,
          tocolor(255, 255, 255, 200),
          0.5,
          RobotoL,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#talkingToNum",
          13,
          50,
          215,
          101,
          tocolor(255, 255, 255, 200),
          0.9,
          Roboto,
          "left",
          "center"
        },
        {
          "talkingLines",
          9,
          13,
          131,
          202,
          370,
          tocolor(255, 255, 255, 200),
          0.75,
          Roboto
        },
        {
          "dynamictext",
          "#fakeInputValue:talkingMessage",
          7,
          96,
          377,
          131,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "left",
          "center"
        }
      },
      buttons = {
        {
          92,
          321,
          122,
          376,
          "cancelCall"
        },
        {
          182,
          96,
          377,
          131,
          "sendMessage"
        }
      }
    },
    ["page:contacts"] = {
      startpos = {13, 54},
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(0, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          15,
          215,
          30,
          tocolor(2, 119, 189, 225)
        },
        {
          "image",
          182,
          20,
          20,
          20,
          "mobile/add.png"
        },
        {
          "text",
          "Névjegyzék",
          13,
          15,
          215,
          45,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {
          "contacts",
          8,
          5,
          45,
          210,
          304,
          tocolor(0, 0, 0, 200),
          0.8,
          Roboto
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          140,
          45,
          210,
          83,
          "deleteContact:1"
        },
        {
          140,
          83,
          210,
          121,
          "deleteContact:2"
        },
        {
          140,
          121,
          210,
          159,
          "deleteContact:3"
        },
        {
          140,
          159,
          210,
          197,
          "deleteContact:4"
        },
        {
          140,
          197,
          210,
          235,
          "deleteContact:5"
        },
        {
          140,
          235,
          210,
          273,
          "deleteContact:6"
        },
        {
          140,
          273,
          210,
          311,
          "deleteContact:7"
        },
        {
          140,
          311,
          210,
          349,
          "deleteContact:8"
        },
        {
          165,
          45,
          210,
          83,
          "smsContact:1"
        },
        {
          165,
          83,
          210,
          121,
          "smsContact:2"
        },
        {
          165,
          121,
          210,
          159,
          "smsContact:3"
        },
        {
          165,
          159,
          210,
          197,
          "smsContact:4"
        },
        {
          165,
          197,
          210,
          235,
          "smsContact:5"
        },
        {
          165,
          235,
          210,
          273,
          "smsContact:6"
        },
        {
          165,
          273,
          210,
          311,
          "smsContact:7"
        },
        {
          165,
          311,
          210,
          349,
          "smsContact:8"
        },
        {
          190,
          45,
          210,
          83,
          "dialContact:1"
        },
        {
          190,
          83,
          210,
          121,
          "dialContact:2"
        },
        {
          190,
          121,
          210,
          159,
          "dialContact:3"
        },
        {
          190,
          159,
          210,
          197,
          "dialContact:4"
        },
        {
          190,
          197,
          210,
          235,
          "dialContact:5"
        },
        {
          190,
          235,
          210,
          273,
          "dialContact:6"
        },
        {
          190,
          273,
          210,
          311,
          "dialContact:7"
        },
        {
          190,
          311,
          210,
          349,
          "dialContact:8"
        },
        {
          182,
          20,
          202,
          40,
          "changepage:addcontact"
        }
      }
    },
    ["page:addcontact"] = {
      startpos = {13, 54},
      fakeInputs = {
        {
          42,
          78,
          209,
          99,
          "addcontactName",
          "normal|15"
        },
        {
          90,
          106,
          209,
          127,
          "addcontactNum",
          "num-only|15"
        }
      },
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(0, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          15,
          215,
          30,
          tocolor(2, 119, 189, 225)
        },
        {
          "image",
          10,
          22,
          16,
          16,
          "mobile/back.png"
        },
        {
          "text",
          "Névjegy hozzáadása",
          32,
          15,
          215,
          45,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "image",
          -148,
          -69,
          512,
          512,
          "mobile/addcontact.png"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {
          "dynamictext",
          "#fakeInputValue:addcontactName",
          47,
          78,
          209,
          99,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#fakeInputValue:addcontactNum",
          95,
          106,
          209,
          127,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "left",
          "center"
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          10,
          22,
          26,
          38,
          "changepage:contacts"
        },
        {
          88,
          153,
          128,
          193,
          "addcontact"
        }
      }
    },
    ["page:messages"] = {
      startpos = {13, 54},
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(0, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          15,
          215,
          30,
          tocolor(2, 119, 189, 225)
        },
        {
          "image",
          182,
          20,
          20,
          20,
          "mobile/add.png"
        },
        {
          "dynamictext",
          "Üzenetek #allnewsms",
          13,
          15,
          215,
          45,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {
          "messageUsers",
          8,
          5,
          45,
          210,
          304,
          tocolor(0, 0, 0, 200),
          0.8,
          Roboto
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          5,
          45,
          210,
          83,
          "messageWith:1"
        },
        {
          5,
          83,
          210,
          121,
          "messageWith:2"
        },
        {
          5,
          121,
          210,
          159,
          "messageWith:3"
        },
        {
          5,
          159,
          210,
          197,
          "messageWith:4"
        },
        {
          5,
          197,
          210,
          235,
          "messageWith:5"
        },
        {
          5,
          235,
          210,
          273,
          "messageWith:6"
        },
        {
          5,
          273,
          210,
          311,
          "messageWith:7"
        },
        {
          5,
          311,
          210,
          349,
          "messageWith:8"
        },
        {
          182,
          20,
          202,
          40,
          "changepage:startmessaging"
        }
      }
    },
    ["page:messagewith"] = {
      startpos = {13, 54},
      fakeInputs = {
        {
          0,
          321,
          215,
          349,
          "smsMessage",
          "normal|160"
        }
      },
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(0, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          15,
          215,
          30,
          tocolor(2, 119, 189, 225)
        },
        {
          "image",
          10,
          22,
          16,
          16,
          "mobile/back.png"
        },
        {
          "dynamictext",
          "SMS: #smswith",
          32,
          15,
          215,
          45,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "image/fakeactive",
          -148,
          -69,
          512,
          512,
          "mobile/sms.png",
          "mobile/smsopen.png",
          "smsMessage"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {
          "dynamictext",
          "#fakeInputValue:smsMessage",
          5,
          242,
          210,
          344,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "left",
          "top"
        },
        {
          "smsLines",
          20,
          5,
          45,
          210,
          275,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "smsMessage",
          84
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          10,
          22,
          26,
          38,
          "changepage:messages"
        },
        {
          190,
          321,
          215,
          349,
          "sendSMS"
        }
      }
    },
    ["page:startmessaging"] = {
      startpos = {13, 54},
      pageFakeInput = "num-only|25",
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(0, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          15,
          215,
          30,
          tocolor(2, 119, 189, 225)
        },
        {
          "image",
          10,
          22,
          16,
          16,
          "mobile/back.png"
        },
        {
          "text",
          "Üzenetváltás kezdése",
          32,
          15,
          215,
          45,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "image",
          -148,
          -69,
          512,
          512,
          "mobile/sms.png"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {
          "text",
          "Telefonszám:",
          5,
          271,
          215,
          349,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#fakeInputValue:page/startmessaging",
          5,
          321,
          215,
          349,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "left",
          "center"
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          10,
          22,
          26,
          38,
          "changepage:messages"
        },
        {
          190,
          321,
          215,
          349,
          "startMessaging"
        }
      }
    },
    ["page:calculator"] = {
      startpos = {13, 54},
      pageFakeInput = "calculator|20",
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(0, 119, 189, 255)
        },
        {
          "image",
          -148,
          -69,
          512,
          512,
          "mobile/calculator.png"
        },
        {
          "dynamictext",
          "#fakeInputValue:page/calculator",
          0,
          35,
          210,
          55.5,
          tocolor(0, 0, 0, 200),
          1,
          Roboto,
          "right",
          "center"
        },
        {
          "dynamictext",
          "#fakeInputValue:calculatorEndValue",
          0,
          70.5,
          210,
          111,
          tocolor(0, 0, 0, 200),
          1,
          Roboto,
          "right",
          "center"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          0,
          136,
          53.75,
          181,
          "injectFakeInput:7"
        },
        {
          53.75,
          136,
          107.5,
          181,
          "injectFakeInput:8"
        },
        {
          107.5,
          136,
          161.2,
          181,
          "injectFakeInput:9"
        },
        {
          0,
          187,
          53.75,
          231,
          "injectFakeInput:4"
        },
        {
          53.75,
          187,
          107.5,
          231,
          "injectFakeInput:5"
        },
        {
          107.5,
          187,
          161.2,
          231,
          "injectFakeInput:6"
        },
        {
          0,
          236,
          53.75,
          281,
          "injectFakeInput:1"
        },
        {
          53.75,
          236,
          107.5,
          281,
          "injectFakeInput:2"
        },
        {
          107.5,
          236,
          161.2,
          281,
          "injectFakeInput:3"
        },
        {
          0,
          291,
          53.75,
          331,
          "injectFakeInput:."
        },
        {
          53.75,
          291,
          107.5,
          331,
          "injectFakeInput:0"
        },
        {
          107.5,
          291,
          161.2,
          331,
          "calculatorEqual"
        },
        {
          167,
          136,
          212,
          166,
          "injectFakeInput:backspace"
        },
        {
          167,
          176,
          212,
          206,
          "injectFakeInput:/"
        },
        {
          167,
          216,
          212,
          246,
          "injectFakeInput:*"
        },
        {
          167,
          256,
          212,
          286,
          "injectFakeInput:-"
        },
        {
          167,
          296,
          212,
          326,
          "injectFakeInput:+"
        }
      }
    },
    ["page:settings"] = {
      startpos = {13, 54},
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(34, 39, 43, 255)
        },
        {
          "rectangle",
          0,
          15,
          215,
          30,
          tocolor(39, 50, 56, 255)
        },
        {
          "rectangle",
          0,
          45,
          215,
          216,
          tocolor(200, 200, 200)
        },
        {
          "rectangle",
          0,
          45,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "rectangle",
          0,
          81,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "rectangle",
          0,
          117,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "rectangle",
          0,
          153,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "rectangle",
          0,
          189,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "rectangle",
          0,
          225,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "image",
          5,
          47.5,
          30,
          30,
          "mobile/wallpaper.png"
        },
        {
          "image",
          5,
          83.5,
          30,
          30,
          "mobile/ringtone.png"
        },
        {
          "image",
          5,
          119.5,
          30,
          30,
          "mobile/ringtone.png"
        },
        {
          "image",
          5,
          155.5,
          30,
          30,
          "mobile/sound.png"
        },
        {
          "image",
          5,
          191.5,
          30,
          30,
          "mobile/vibrate.png"
        },
        {
          "image",
          5,
          227.5,
          30,
          30,
          "mobile/sim.png"
        },
        {
          "isSoundOn",
          180,
          163,
          30,
          15
        },
        {
          "isVibrateOn",
          180,
          199,
          30,
          15
        },
        {
          "text",
          "Háttérkép",
          40,
          45,
          35,
          70,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#currentWallpaper",
          45,
          45,
          35,
          95,
          tocolor(39, 50, 56, 200),
          0.7,
          Roboto,
          "left",
          "center"
        },
        {
          "text",
          "Csengőhang",
          40,
          81,
          35,
          106,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#currentRingtone",
          45,
          81,
          35,
          131,
          tocolor(39, 50, 56, 200),
          0.7,
          Roboto,
          "left",
          "center"
        },
        {
          "text",
          "Értesítéshang",
          40,
          117,
          35,
          142,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "dynamictext",
          "#currentNotisound",
          45,
          117,
          35,
          167,
          tocolor(39, 50, 56, 200),
          0.7,
          Roboto,
          "left",
          "center"
        },
        {
          "text",
          "Hang",
          40,
          153,
          35,
          188,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "text",
          "Vibrálás",
          40,
          189,
          35,
          224,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "dynamictext",
          "Számom: #myPhoneNumber",
          40,
          225,
          35,
          260,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "text",
          "Beállítások",
          13,
          15,
          215,
          45,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {"changemenu"}
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          0,
          45,
          215,
          80,
          "changeMenuShow:wallpaper"
        },
        {
          0,
          81,
          215,
          116,
          "changeMenuShow:ringtone"
        },
        {
          0,
          117,
          215,
          152,
          "changeMenuShow:notisound"
        },
        {
          0,
          153,
          215,
          188,
          "toggleSoundOn"
        },
        {
          0,
          189,
          215,
          224,
          "toggleVibrateOn"
        },
        {
          10,
          21,
          205,
          46,
          "changeMenuAction:1"
        },
        {
          10,
          47,
          205,
          72,
          "changeMenuAction:2"
        },
        {
          10,
          73,
          205,
          98,
          "changeMenuAction:3"
        },
        {
          10,
          99,
          205,
          124,
          "changeMenuAction:4"
        },
        {
          10,
          125,
          205,
          150,
          "changeMenuAction:5"
        },
        {
          10,
          151,
          205,
          176,
          "changeMenuAction:6"
        },
        {
          10,
          177,
          205,
          202,
          "changeMenuAction:7"
        },
        {
          10,
          203,
          205,
          228,
          "changeMenuAction:8"
        },
        {
          10,
          229,
          205,
          254,
          "changeMenuAction:9"
        },
        {
          10,
          255,
          205,
          280,
          "changeMenuAction:10"
        },
        {
          10,
          281,
          205,
          306,
          "changeMenuAction:11"
        },
        {
          10,
          307,
          205,
          332,
          "changeMenuAction:12"
        },
        {
          10,
          333,
          205,
          358,
          "changeMenuAction:13"
        },
        {
          184,
          21,
          205,
          46,
          "changeMenuListen:1"
        },
        {
          184,
          47,
          205,
          72,
          "changeMenuListen:2"
        },
        {
          184,
          73,
          205,
          98,
          "changeMenuListen:3"
        },
        {
          184,
          99,
          205,
          124,
          "changeMenuListen:4"
        },
        {
          184,
          125,
          205,
          150,
          "changeMenuListen:5"
        },
        {
          184,
          151,
          205,
          176,
          "changeMenuListen:6"
        },
        {
          184,
          177,
          205,
          202,
          "changeMenuListen:7"
        },
        {
          184,
          203,
          205,
          228,
          "changeMenuListen:8"
        },
        {
          184,
          229,
          205,
          254,
          "changeMenuListen:9"
        },
        {
          184,
          255,
          205,
          280,
          "changeMenuListen:10"
        },
        {
          184,
          281,
          205,
          306,
          "changeMenuListen:11"
        },
        {
          184,
          307,
          205,
          332,
          "changeMenuListen:12"
        }
      }
    },
    ["page:camera"] = {
      startpos = {0, 0},
      contents = {
        {
          "image",
          -135,
          -15,
          512,
          512,
          "mobile/moto-g.png",
          -90
        },
        {
          "screenSource"
        },
        {
          "image",
          -135,
          -15,
          512,
          512,
          "mobile/selfie.png",
          -90
        },
        {
          "image",
          -135,
          -15,
          512,
          512,
          "mobile/buttons.png",
          -90
        }
      },
      buttons = {
        {
          287,
          231,
          309,
          253,
          "changepage:home"
        },
        {
          -66,
          134,
          287,
          349,
          "takePicture"
        },
        {
          -66,
          134,
          -24,
          190,
          "selfieMode"
        }
      }
    },
    ["page:advertise"] = {
      startpos = {13, 54},
      fakeInputs = {
        {
          0,
          321,
          215,
          349,
          "advertiseMessage",
          "normal|100"
        }
      },
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(0, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          15,
          215,
          30,
          tocolor(2, 119, 189, 225)
        },
        {
          "text",
          "Hírdetésfeladás",
          13,
          15,
          215,
          45,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {
          "rectangle",
          0,
          45,
          215,
          72,
          tocolor(200, 200, 200)
        },
        {
          "rectangle",
          0,
          45,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "rectangle",
          0,
          81,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "image",
          5,
          47.5,
          30,
          30,
          "mobile/vibrate.png"
        },
        {
          "image",
          5,
          83.5,
          30,
          30,
          "mobile/ringtone.png"
        },
        {
          "text",
          "Hírdetések\nmegjelenítése",
          40,
          45,
          35,
          80,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "text",
          "Telefonszám\nmegjelenítése",
          40,
          81,
          35,
          116,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "isAdsOn",
          180,
          55,
          30,
          15
        },
        {
          "isAdNumberOn",
          180,
          91,
          30,
          15
        },
        {
          "image/fakeactive",
          -148,
          -69,
          512,
          512,
          "mobile/sms.png",
          "mobile/smsopen.png",
          "advertiseMessage"
        },
        {
          "dynamictext",
          "#fakeInputValue:advertiseMessage",
          5,
          242,
          210,
          344,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "left",
          "top"
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          190,
          321,
          215,
          349,
          "sendAdvertisement"
        },
        {
          0,
          45,
          215,
          80,
          "toggleAdsOn"
        },
        {
          0,
          81,
          215,
          116,
          "toggleAdNumberOn"
        }
      }
    },
    ["page:seeNion"] = {
      startpos = {13, 54},
      fakeInputs = {
        {
          0,
          321,
          215,
          349,
          "nionAdvertiseMessage",
          "normal|100"
        }
      },
      contents = {
        {
          "rectangle",
          0,
          0,
          215,
          377,
          tocolor(255, 255, 255, 255)
        },
        {
          "taskbar",
          tocolor(0, 119, 189, 255)
        },
        {
          "rectangle",
          0,
          15,
          215,
          30,
          tocolor(2, 119, 189, 225)
        },
        {
          "text",
          "SealNion hírdetésfeladás",
          13,
          15,
          215,
          45,
          tocolor(255, 255, 255, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 255)
        },
        {
          "rectangle",
          0,
          45,
          215,
          72,
          tocolor(200, 200, 200)
        },
        {
          "rectangle",
          0,
          45,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "rectangle",
          0,
          81,
          215,
          35,
          tocolor(255, 255, 255)
        },
        {
          "image",
          5,
          47.5,
          30,
          30,
          "mobile/vibrate.png"
        },
        {
          "image",
          5,
          83.5,
          30,
          30,
          "mobile/ringtone.png"
        },
        {
          "text",
          "Hírdetések\nmegjelenítése",
          40,
          45,
          35,
          80,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "text",
          "Telefonszám\nmegjelenítése",
          40,
          81,
          35,
          116,
          tocolor(39, 50, 56, 200),
          0.8,
          Roboto,
          "left",
          "center"
        },
        {
          "isNionAdsOn",
          180,
          55,
          30,
          15
        },
        {
          "isNionAdNumberOn",
          180,
          91,
          30,
          15
        },
        {
          "image/fakeactive",
          -148,
          -69,
          512,
          512,
          "mobile/sms.png",
          "mobile/smsopen.png",
          "nionAdvertiseMessage"
        },
        {
          "dynamictext",
          "#fakeInputValue:nionAdvertiseMessage",
          5,
          242,
          210,
          344,
          tocolor(0, 0, 0, 200),
          0.75,
          Roboto,
          "left",
          "top"
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          190,
          321,
          215,
          349,
          "sendNionAdvertisement"
        },
        {
          0,
          45,
          215,
          80,
          "toggleNionAdsOn"
        },
        {
          0,
          81,
          215,
          116,
          "toggleNionAdNumberOn"
        }
      }
    },
    ["page:game"] = {
      startpos = {13, 54},
      fakeInputs = {},
      contents = {
        {
          "gameBackground"
        },
        {
          "gameBrowser"
        },
        {
          "buttons",
          tocolor(0, 0, 0, 100)
        }
      },
      buttons = {
        {
          88,
          349,
          128,
          377,
          "changepage:home"
        },
        {
          287,
          231,
          309,
          253,
          "changepage:home"
        }
      }
    }
  }
}
local talkingText = ""
local callerNumber = 0
local callingWith = false
local talkingWith = false
local talkingToNumber = 0
local talkerName = false
local talkingLines = {}
local phoneActive = false
local myPhoneNumber = 0
local contactsOffset = 0
local callerName = false
local reversedContacts = {}
local messagingWith = false
local isInSelfieMode = false
local ringtones = {
  "Atria",
  "Callisto",
  "Dione",
  "Ganymede",
  "Luna",
  "Oberon",
  "Phobos",
  "Pyxis",
  "Sedna",
  "Titania",
  "Triton",
  "Umbriel"
}
local notisounds = {
  "Ariel",
  "Carme",
  "Ceres",
  "Elara",
  "Europa",
  "Lapetus",
  "Lo",
  "Rhea",
  "Salacia",
  "Tethys",
  "Titan"
}
local currentGame = ""
local systemSound = false
addEvent("addToMySMSLine", true)
addEventHandler("addToMySMSLine", getRootElement(), function(msg, messagingWith, error)
  addSMSLine({
    msg,
    "left",
    error
  }, messagingWith)
end)
addEvent("lineIsBusy", true)
addEventHandler("lineIsBusy", getRootElement(), function()
  triggerEvent("talkingSysMessage", localPlayer, "#d75959*Foglalt!*")
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
  systemSound = playSound("mobile/sounds/2/mobilebusy.mp3", true)
end)
addEvent("callEnd", true)
addEventHandler("callEnd", getRootElement(), function()
  callerNumber = 0
  callingWith = false
  talkingWith = false
  talkingToNumber = 0
  talkingLines = {}
  commandHandler("changepage:home")
  activeFakeInput = false
  fakeInputValues = {}
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
  playSound("mobile/sounds/2/mobiledecline.mp3")
end)
addEvent("onAdvertisement", true)
addEventHandler("onAdvertisement", getRootElement(), function(message, number)
  if isAdsOn == 1 or getElementData(localPlayer, "adminDuty") == 1 then
    outputChatBox(" #32ba9dHÍRDETÉS:#dfb551 " .. message:gsub("#%x%x%x%x%x%x", ""), 0, 255, 64, true)
    if number then
      outputChatBox(" #32ba9dKapcsolat:#dfb551 " .. tostring(number) .. ".", 0, 255, 64, true)
    end
  end
end)
local lastSMSSend = 0
local canUseSeeNion = false
local seeNionGroups = {
  [5] = true,
  [6] = true,
  [7] = true,
  [9] = true
}
addEventHandler("onClientResourceStart", getResourceRootElement(), function(data)
  local val = getElementData(localPlayer, "player.groups")
  local count = 0
  canUseSeeNion = true
  for k, v in pairs(val) do
    count = count + 1
    if not seeNionGroups[k] then
      canUseSeeNion = false
      break
    end
  end
  if count >= 1 then
    canUseSeeNion = true
  end
end)
addEventHandler("onClientElementDataChange", getRootElement(), function(data)
  if source == localPlayer and data == "player.groups" then
    local val = getElementData(localPlayer, "player.groups")
    local count = 0
    canUseSeeNion = true
    for k, v in pairs(val) do
      count = count + 1
      if not seeNionGroups[k] then
        canUseSeeNion = false
        break
      end
    end
    if count >= 1 then
      canUseSeeNion = true
    end
  end
end)
addEvent("onNionAdvertisement", true)
addEventHandler("onNionAdvertisement", getRootElement(), function(message, number)
  if getElementData(localPlayer, "loggedIn") and canUseSeeNion and isNionAdsOn == 1 then
    outputChatBox(" #d75959SealNion - HÍRDETÉS:#F0E76C " .. message:gsub("#%x%x%x%x%x%x", ""), 0, 255, 64, true)
    if number then
      outputChatBox(" #d75959Kapcsolat:#F0E76C " .. tostring(number) .. ".", 0, 255, 64, true)
    end
  end
end)
local taxiGuiActive = false
local mechanicGuiActive = false
local ambulanceGuiActive = false
local firemanGuiActive = false
local policeGuiActive = false
local towGuiActive = false
addEvent("openPhone", true)
addEventHandler("openPhone", getRootElement(), function(num)
  if taxiGuiActive then
    return
  end
  if mechanicGuiActive then
    return
  end
  if ambulanceGuiActive then
    return
  end
  if firemanGuiActive then
    return
  end
  if policeGuiActive then
    return
  end
  if towGuiActive then
    return
  end
  if phoneActive and (currentPage == "talking" or currentPage == "incoming") then
    return
  end
  if currentRingtone and not ringtones[currentRingtone] then
    currentRingtone = 1
  end
  if currentNotisound and not notisounds[currentNotisound] then
    currentNotisound = 1
  end
  if currentWallpaper and (1 > currentWallpaper or currentWallpaper > 13) then
    currentWallpaper = 1
  end
  phoneActive = not phoneActive
  if phoneActive then
    sealexports.seal_chat:localActionC(localPlayer, "elővesz egy telefont.")
  else
    sealexports.seal_chat:localActionC(localPlayer, "elrak egy telefont.")
  end
  triggerServerEvent("attachMobilePhone", localPlayer, phoneActive)
  myPhoneNumber = num
  activeButton = false
  commandHandler("changepage:lockscreen")
  reversedContacts = {}
  for k = 1, #contacts do
    if contacts[k] then
      reversedContacts[contacts[k][2]] = contacts[k][1]
    end
  end
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
  if isTimer(callTimer) then
    killTimer(callTimer)
  end
end)
function isPhoneActive()
  return phoneActive
end
addEvent("incomingCall", true)
addEventHandler("incomingCall", getRootElement(), function(num, phoneNumber)
  callerNumber = tonumber(num)
  callerName = false
  if reversedContacts[tonumber(num)] then
    callerName = reversedContacts[tonumber(num)]
  end
  talkingToNumber = tonumber(num)
  callingWith = source
  addCallHistory({
    tonumber(num),
    "missedicon"
  })
  missedCalls = missedCalls + 1
  phoneActive = true
  triggerServerEvent("attachMobilePhone", localPlayer, phoneActive)
  myPhoneNumber = phoneNumber
  if isSoundOn == 1 then
    triggerServerEvent("playRingtone", localPlayer, getElementsByType("player", getRootElement(), true), currentRingtone)
  end
  if isVibrateOn == 1 then
    triggerServerEvent("playVibrate", localPlayer, getElementsByType("player", getRootElement(), true))
  end
  talkingText = "Beszélgetés"
  commandHandler("changepage:incomingCall")
end)
addEvent("someoneAccepted", true)
addEventHandler("someoneAccepted", getRootElement(), function()
  addTalkingLineColored({
    "#598ed7*Felvették a telefont*",
    "left"
  })
  talkingWith = source
  talkingText = "Beszélgetés"
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
end)
addEvent("talkingSysMessage", true)
addEventHandler("talkingSysMessage", getRootElement(), function(msg)
  addTalkingLineColored({msg, "left"})
end)
addEvent("callingWith", true)
addEventHandler("callingWith", getRootElement(), function(num)
  if source ~= localPlayer then
    callingWith = source
  else
    callingWith = num
  end
end)
addEvent("sendPhoneMessage", true)
addEventHandler("sendPhoneMessage", getRootElement(), function(message)
  addTalkingLine({message, "left"})
end)
addEvent("gotSMS", true)
addEventHandler("gotSMS", getRootElement(), function(gotnumber, message)
  if not messages[gotnumber] then
    table.insert(messageNumbers, gotnumber)
    messages[gotnumber] = {}
  end
  addSMSLine({message, "right"}, gotnumber)
  if messagingWith ~= gotnumber then
    newMessages[gotnumber] = (newMessages[gotnumber] or 0) + 1
    if isSoundOn == 1 then
      triggerServerEvent("playNotificationSound", localPlayer, getElementsByType("player", getRootElement(), true), currentNotisound)
    end
  end
  allNewMessages = 0
  for k, v in pairs(newMessages) do
    allNewMessages = allNewMessages + v
  end
end)
local rings = {}
local vibrates = {}
addEvent("playRingtone", true)
addEventHandler("playRingtone", getRootElement(), function(tone)
  if source ~= localPlayer then
    local x, y, z = getElementPosition(source)
    rings[source] = playSound3D("mobile/sounds/ring" .. string.lower(ringtones[tone]) .. ".mp3", x, y, z, true)
    attachElements(rings[source], source)
  else
    rings[source] = playSound("mobile/sounds/ring" .. string.lower(ringtones[tone]) .. ".mp3", true)
  end
end)
addEventHandler("onClientPlayerQuit", getRootElement(), function()
  if isElement(rings[source]) then
    destroyElement(rings[source])
  end
  if isElement(vibrates[source]) then
    destroyElement(vibrates[source])
  end
end)
addEvent("playVibrate", true)
addEventHandler("playVibrate", getRootElement(), function()
  if source ~= localPlayer then
    local x, y, z = getElementPosition(source)
    vibrates[source] = playSound3D("mobile/sounds/vibrate.mp3", x, y, z, true)
    attachElements(vibrates[source], source)
  else
    vibrates[source] = playSound("mobile/sounds/vibrate.mp3", true)
  end
end)
addEvent("destroySound", true)
addEventHandler("destroySound", getRootElement(), function()
  if isElement(rings[source]) then
    destroyElement(rings[source])
  end
  if isElement(vibrates[source]) then
    destroyElement(vibrates[source])
  end
end)
addEvent("playNotificationSound", true)
addEventHandler("playNotificationSound", getRootElement(), function(tone)
  if source ~= localPlayer then
    local x, y, z = getElementPosition(source)
    local x2, y2, z2 = getElementPosition(localPlayer)
    local vol = 1 - getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) / 2.5
    if 0 < vol and getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 2.5 then
      local s = playSound("mobile/sounds/noti.mp3")
      setSoundVolume(s, vol)
    end
  else
    playSound("mobile/sounds/sms" .. string.lower(notisounds[tone]) .. ".mp3")
  end
end)
local startTime = 0
local duration = 250
local flashScreenRender = false
addEventHandler("onClientRender", getRootElement(), function()
  if ambulanceGuiActive then
    local buttons = {}
    local width = respc(300)
    local height = respc(105)
    dxDrawRectangle(screenX / 2 - width / 2, screenY / 2 - height / 2, width, respc(30), tocolor(0, 0, 0, 200))
    dxDrawRectangle(screenX / 2 - width / 2, screenY / 2 - height / 2, width, height, tocolor(0, 0, 0, 200))
    dxDrawText("#32ba9dSeal#FFFFFFMTA - Mentő", screenX / 2 - width / 2 + respc(7.5), screenY / 2 - height / 2, screenX / 2 - width / 2 + width, screenY / 2 - height / 2 + respc(30), tocolor(255, 255, 255), 1, Roboto, "left", "center", false, false, false, true)
    if ambulanceGuiActive == "calledAmbulance" then
      dxDrawText("Már hívtál mentőt. Szeretnéd lemondani?", screenX / 2 - width / 2, screenY / 2 - height / 2 + respc(30), screenX / 2 - width / 2 + width, screenY / 2 - height / 2 + respc(70), tocolor(255, 255, 255), 0.8, Roboto, "center", "center", false, false, false, true)
    else
      dxDrawText("Szeretnél mentőt hívni?", screenX / 2 - width / 2, screenY / 2 - height / 2 + respc(30), screenX / 2 - width / 2 + width, screenY / 2 - height / 2 + respc(70), tocolor(255, 255, 255), 0.8, Roboto, "center", "center", false, false, false, true)
    end
    local a = 200
    if activeButton == "yes" then
      a = 255
    end
    dxDrawRectangle(screenX / 2 - width / 2 + respc(5), screenY / 2 - height / 2 + respc(75), width / 2 - respc(7.5), respc(25), tocolor(50, 186, 157, a))
    dxDrawText("Igen", screenX / 2 - width / 2 + respc(5), screenY / 2 - height / 2 + respc(75), screenX / 2 - width / 2 + respc(5) + width / 2 - respc(7.5), screenY / 2 - height / 2 + respc(75) + respc(25), tocolor(0, 0, 0), 0.8, Roboto, "center", "center", false, false, false, true)
    buttons.yes = {
      screenX / 2 - width / 2 + respc(5),
      screenY / 2 - height / 2 + respc(75),
      screenX / 2 - width / 2 + respc(5) + width / 2 - respc(7.5),
      screenY / 2 - height / 2 + respc(75) + respc(25)
    }
    local a = 200
    if activeButton == "no" then
      a = 255
    end
    dxDrawRectangle(screenX / 2 - width / 2 + respc(2, 5) + width / 2, screenY / 2 - height / 2 + respc(75), width / 2 - respc(7.5), respc(25), tocolor(215, 89, 89, a))
    dxDrawText("Nem", screenX / 2 - width / 2 + respc(2, 5) + width / 2, screenY / 2 - height / 2 + respc(75), screenX / 2 - width / 2 + respc(2, 5) + width / 2 + width / 2 - respc(7.5), screenY / 2 - height / 2 + respc(75) + respc(25), tocolor(0, 0, 0), 0.8, Roboto, "center", "center", false, false, false, true)
    buttons.no = {
      screenX / 2 - width / 2 + respc(2, 5) + width / 2,
      screenY / 2 - height / 2 + respc(75),
      screenX / 2 - width / 2 + respc(2, 5) + width / 2 + width / 2 - respc(7.5),
      screenY / 2 - height / 2 + respc(75) + respc(25)
    }
    local cx, cy = getCursorPosition()
    activeButton = false
    if cx and cy then
      cx, cy = cx * screenX, cy * screenY
      for k, v in pairs(buttons) do
        if cx >= v[1] and cy >= v[2] and cx <= v[3] and cy <= v[4] then
          activeButton = k
        end
      end
    end
  end
  if policeGuiActive then
    local buttons = {}
    local width = respc(300)
    local height = respc(105)
    if policeGuiActive ~= "calledPolice" then
      height = height + respc(30)
    end
    dxDrawRectangle(screenX / 2 - width / 2, screenY / 2 - height / 2, width, respc(30), tocolor(0, 0, 0, 200))
    dxDrawRectangle(screenX / 2 - width / 2, screenY / 2 - height / 2, width, height, tocolor(0, 0, 0, 200))
    dxDrawText("#32ba9dSeal#FFFFFFMTA - Rendőrség", screenX / 2 - width / 2 + respc(7.5), screenY / 2 - height / 2, screenX / 2 - width / 2 + width, screenY / 2 - height / 2 + respc(30), tocolor(255, 255, 255), 1, Roboto, "left", "center", false, false, false, true)
    if policeGuiActive == "calledPolice" then
      dxDrawText("Már hívtál járőrt. Szeretnéd lemondani?", screenX / 2 - width / 2, screenY / 2 - height / 2 + respc(30), screenX / 2 - width / 2 + width, screenY / 2 - height / 2 + respc(70), tocolor(255, 255, 255), 0.8, Roboto, "center", "center", false, false, false, true)
    else
      dxDrawText("Szeretnél járőrt hívni?", screenX / 2 - width / 2, screenY / 2 - height / 2 + respc(30), screenX / 2 - width / 2 + width, screenY / 2 - height / 2 + respc(70), tocolor(255, 255, 255), 0.8, Roboto, "center", "center", false, false, false, true)
    end
    local a = 200
    if activeButton == "yes" then
      a = 255
    end
    dxDrawRectangle(screenX / 2 - width / 2 + respc(5), screenY / 2 - height / 2 + respc(75), width / 2 - respc(7.5), respc(25), tocolor(50, 186, 157, a))
    dxDrawText("Igen", screenX / 2 - width / 2 + respc(5), screenY / 2 - height / 2 + respc(75), screenX / 2 - width / 2 + respc(5) + width / 2 - respc(7.5), screenY / 2 - height / 2 + respc(75) + respc(25), tocolor(0, 0, 0), 0.8, Roboto, "center", "center", false, false, false, true)
    buttons.yes = {
      screenX / 2 - width / 2 + respc(5),
      screenY / 2 - height / 2 + respc(75),
      screenX / 2 - width / 2 + respc(5) + width / 2 - respc(7.5),
      screenY / 2 - height / 2 + respc(75) + respc(25)
    }
    local a = 200
    if activeButton == "no" then
      a = 255
    end
    dxDrawRectangle(screenX / 2 - width / 2 + respc(2, 5) + width / 2, screenY / 2 - height / 2 + respc(75), width / 2 - respc(7.5), respc(25), tocolor(215, 89, 89, a))
    dxDrawText("Nem", screenX / 2 - width / 2 + respc(2, 5) + width / 2, screenY / 2 - height / 2 + respc(75), screenX / 2 - width / 2 + respc(2, 5) + width / 2 + width / 2 - respc(7.5), screenY / 2 - height / 2 + respc(75) + respc(25), tocolor(0, 0, 0), 0.8, Roboto, "center", "center", false, false, false, true)
    buttons.no = {
      screenX / 2 - width / 2 + respc(2, 5) + width / 2,
      screenY / 2 - height / 2 + respc(75),
      screenX / 2 - width / 2 + respc(2, 5) + width / 2 + width / 2 - respc(7.5),
      screenY / 2 - height / 2 + respc(75) + respc(25)
    }
    if policeGuiActive ~= "calledPolice" then
      local a = 200
      if activeButton == "report" then
        a = 255
      end
      dxDrawRectangle(screenX / 2 - width / 2 + respc(5), screenY / 2 - height / 2 + respc(75) + respc(30), width - respc(10), respc(25), tocolor(50, 186, 157, a))
      dxDrawText("Inkább bejelentést teszek", screenX / 2 - width / 2 + respc(5), screenY / 2 - height / 2 + respc(75) + respc(30), screenX / 2 - width / 2 + respc(5) + width - respc(10), screenY / 2 - height / 2 + respc(75) + respc(30) + respc(25), tocolor(0, 0, 0), 0.8, Roboto, "center", "center", false, false, false, true)
      buttons.report = {
        screenX / 2 - width / 2 + respc(5),
        screenY / 2 - height / 2 + respc(75) + respc(30),
        screenX / 2 - width / 2 + respc(5) + width - respc(10),
        screenY / 2 - height / 2 + respc(75) + respc(30) + respc(25)
      }
    end
    local cx, cy = getCursorPosition()
    activeButton = false
    if cx and cy then
      cx, cy = cx * screenX, cy * screenY
      for k, v in pairs(buttons) do
        if cx >= v[1] and cy >= v[2] and cx <= v[3] and cy <= v[4] then
          activeButton = k
        end
      end
    end
  end
  if policeReportGuiActive then
    local buttons = {}
    local width = respc(300)
    local height = respc(155)
    dxDrawRectangle(screenX / 2 - width / 2, screenY / 2 - height / 2, width, respc(30), tocolor(0, 0, 0, 200))
    dxDrawRectangle(screenX / 2 - width / 2, screenY / 2 - height / 2, width, height, tocolor(0, 0, 0, 200))
    dxDrawText("#32ba9dSeal#FFFFFFMTA - Rendőrségi bejelentés", screenX / 2 - width / 2 + respc(7.5), screenY / 2 - height / 2, screenX / 2 - width / 2 + width, screenY / 2 - height / 2 + respc(30), tocolor(255, 255, 255), 1, Roboto, "left", "center", false, false, false, true)
    dxDrawText("Bejelentés szövege:\n" .. replaceDynamicText("#fakeInputValue:policeReport"), screenX / 2 - width / 2 + respc(7.5), screenY / 2 - height / 2 + respc(30) + respc(5), screenX / 2 - width / 2 + width - respc(7.5), screenY / 2 - height / 2 + respc(70), tocolor(255, 255, 255), 0.8, Roboto, "center", "top", false, true)
    local a = 200
    if activeButton == "yes" then
      a = 255
    end
    dxDrawRectangle(screenX / 2 - width / 2 + respc(5), screenY / 2 - height / 2 + respc(75) + respc(50), width / 2 - respc(7.5), respc(25), tocolor(50, 186, 157, a))
    dxDrawText("Igen", screenX / 2 - width / 2 + respc(5), screenY / 2 - height / 2 + respc(75) + respc(50), screenX / 2 - width / 2 + respc(5) + width / 2 - respc(7.5), screenY / 2 - height / 2 + respc(75) + respc(50) + respc(25), tocolor(0, 0, 0), 0.8, Roboto, "center", "center", false, false, false, true)
    buttons.yes = {
      screenX / 2 - width / 2 + respc(5),
      screenY / 2 - height / 2 + respc(75) + respc(50),
      screenX / 2 - width / 2 + respc(5) + width / 2 - respc(7.5),
      screenY / 2 - height / 2 + respc(75) + respc(50) + respc(25)
    }
    local a = 200
    if activeButton == "no" then
      a = 255
    end
    dxDrawRectangle(screenX / 2 - width / 2 + respc(2, 5) + width / 2, screenY / 2 - height / 2 + respc(75) + respc(50), width / 2 - respc(7.5), respc(25), tocolor(215, 89, 89, a))
    dxDrawText("Nem", screenX / 2 - width / 2 + respc(2, 5) + width / 2, screenY / 2 - height / 2 + respc(75) + respc(50), screenX / 2 - width / 2 + respc(2, 5) + width / 2 + width / 2 - respc(7.5), screenY / 2 - height / 2 + respc(75) + respc(50) + respc(25), tocolor(0, 0, 0), 0.8, Roboto, "center", "center", false, false, false, true)
    buttons.no = {
      screenX / 2 - width / 2 + respc(2, 5) + width / 2,
      screenY / 2 - height / 2 + respc(75) + respc(50),
      screenX / 2 - width / 2 + respc(2, 5) + width / 2 + width / 2 - respc(7.5),
      screenY / 2 - height / 2 + respc(75) + respc(50) + respc(25)
    }
    local cx, cy = getCursorPosition()
    activeButton = false
    if cx and cy then
      cx, cy = cx * screenX, cy * screenY
      for k, v in pairs(buttons) do
        if cx >= v[1] and cy >= v[2] and cx <= v[3] and cy <= v[4] then
          activeButton = k
        end
      end
    end
  end
  if flashScreenRender then
    local now = getTickCount()
    local elapsedTime = now - startTime
    local elapsedTime2 = now - (startTime + 250)
    local progress = elapsedTime / duration
    local progress2 = elapsedTime2 / duration
    local alpha = 0
    if progress <= 1 then
      alpha = interpolateBetween(0, 0, 0, 200, 200, 200, progress, "Linear")
    else
      alpha = interpolateBetween(200, 200, 200, 0, 0, 0, progress2, "Linear")
    end
    if 1 < progress2 then
      flashScreenRender = false
    end
    dxDrawRectangle(0, 0, screenX, screenY, tocolor(255, 255, 255, alpha))
  end
end)
function addSMSLine(msg, gotnumber)
  gotnumber = tonumber(gotnumber)
  local tmp = {}
  for i = 1, 200 do
    if messages[gotnumber] and messages[gotnumber][i] then
      tmp[i + 1] = messages[gotnumber][i]
    end
  end
  tmp[1] = {
    utf8.gsub(msg[1], "#%x%x%x%x%x%x", ""),
    msg[2],
    msg[3]
  }
  if isSoundOn == 1 and messagingWith == gotnumber then
    playSound("mobile/sounds/bubble.mp3")
  end
  messages[gotnumber] = {}
  for i = 1, #tmp do
    messages[gotnumber][i] = tmp[i]
  end
end
function addTalkingLineColored(msg)
  local tmp = {}
  for i = 1, 10 do
    if talkingLines[i] then
      tmp[i + 1] = talkingLines[i]
    end
  end
  tmp[1] = msg
  talkingLines = {}
  for i = 1, #tmp do
    talkingLines[i] = tmp[i]
  end
end
function addTalkingLine(msg)
  local tmp = {}
  for i = 1, 10 do
    if talkingLines[i] then
      tmp[i + 1] = talkingLines[i]
    end
  end
  tmp[1] = {
    utf8.gsub(msg[1], "#%x%x%x%x%x%x", ""),
    msg[2]
  }
  talkingLines = {}
  for i = 1, #tmp do
    talkingLines[i] = tmp[i]
  end
end
local callHistoryOffset = 0
function addCallHistory(msg)
  local tmp = {}
  for i = 1, 30 do
    if callHistory[i] then
      tmp[i + 1] = callHistory[i]
    end
  end
  tmp[1] = msg
  for i = 1, #tmp do
    callHistory[i] = tmp[i]
  end
end
local smsWithOffset = 0
function replaceDynamicText(text)
  local hour = getRealTime().hour
  local minute = getRealTime().minute
  if utf8.len(hour) == 1 then
    hour = 0 .. hour
  end
  if utf8.len(minute) == 1 then
    minute = 0 .. minute
  end
  if string.find(text, "#fakeInputValue:") then
    local active = string.gsub(text, "#fakeInputValue:", "")
    local active2, numOnly, maxChar, noFlash = getActiveFakeInput()
    if active2 == active and not noFlash then
      text = (fakeInputValues[active] or "") .. "|"
    else
      text = fakeInputValues[active] or ""
    end
  end
  text = string.gsub(text, "#currenttime", hour .. ":" .. minute)
  if reversedContacts[callerNumber] then
    text = string.gsub(text, "#caller", reversedContacts[callerNumber])
  else
    text = string.gsub(text, "#caller", callerNumber)
  end
  if reversedContacts[callerNumber] then
    text = string.gsub(text, "#callNum", callerNumber)
  else
    text = string.gsub(text, "#callNum", "")
  end
  if reversedContacts[talkingToNumber] then
    text = string.gsub(text, "#talkingToNumber", reversedContacts[talkingToNumber])
  else
    text = string.gsub(text, "#talkingToNumber", talkingToNumber)
  end
  if reversedContacts[talkingToNumber] then
    text = string.gsub(text, "#talkingToNum", talkingToNumber)
  else
    text = string.gsub(text, "#talkingToNum", "")
  end
  if messagingWith then
    if reversedContacts[messagingWith] then
      text = string.gsub(text, "#smswith", reversedContacts[messagingWith] .. " (" .. messagingWith .. ")")
    else
      text = string.gsub(text, "#smswith", messagingWith)
    end
  end
  if 0 < allNewMessages then
    text = string.gsub(text, "#allnewsms", " [" .. allNewMessages .. " új üzenet]")
  else
    text = string.gsub(text, "#allnewsms", "")
  end
  text = string.gsub(text, "#currentRingtone", ringtones[currentRingtone])
  text = string.gsub(text, "#currentNotisound", notisounds[currentNotisound])
  text = string.gsub(text, "#currentWallpaper", "Háttér " .. currentWallpaper)
  text = string.gsub(text, "#myPhoneNumber", myPhoneNumber)
  text = string.gsub(text, "#talkingText", talkingText)
  return text
end
local currentChanging = false
function getPositionFromElementOffset(element, offX, offY, offZ)
  local m = getElementMatrix(element)
  local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
  local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
  local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
  return x, y, z
end
local selfieOffset, selfieOffsetZ = 0, 0
local selfieMoveOffset, selfieMoveOffsetZ = 0, 0
addEventHandler("onClientCursorMove", getRootElement(), function(cX, cY, aX, aY)
  if not isCursorShowing() and isInSelfieMode then
    local width, height = guiGetScreenSize()
    aX = (aX - width / 2) / width
    aY = (aY - height / 2) / height
    if 0 < aY and 0 < selfieOffsetZ or aY < 0 and selfieOffsetZ < 1 then
      selfieOffsetZ = selfieOffsetZ - aY
    end
    if selfieOffsetZ < 0 then
      selfieOffsetZ = 0
    end
    if 1 < selfieOffsetZ then
      selfieOffsetZ = 1
    end
    if 0 < aX and -30 < selfieOffset or aX < 0 and selfieOffset < 30 then
      selfieOffset = selfieOffset - aX * 75
    end
    if selfieOffset < -30 then
      selfieOffset = -30
    end
    if 30 < selfieOffset then
      selfieOffset = 30
    end
  end
end)
local incomingButtonDown = false
local hextrisX, hextrisY
function drawPhoneComponent(x, y, datas)
  if datas[1] == "image" then
    dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), datas[6], datas[7])
  elseif datas[1] == "incoming" then
    if incomingButtonDown then
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/incoming.png")
    else
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/incoming_pre.png")
    end
  elseif datas[1] == "screenSource" then
    dxDrawImage(x - resp(66), y + resp(134), resp(377), resp(215), screenSource)
    if isInSelfieMode then
      local x, y, z = getElementPosition(localPlayer)
      local rotX, rotY, rotZ = getElementRotation(localPlayer)
      local centerX = 0
      local centerY = 0
      local pointX = 1
      local pointY = 0
      local angle = math.rad(selfieOffset + rotZ - 90)
      local drawX = centerX + (pointX - centerX) * math.cos(angle) - (pointY - centerY) * math.sin(angle)
      local drawY = centerY + (pointX - centerX) * math.sin(angle) + (pointY - centerY) * math.cos(angle)
      local pointX = -0.8
      local pointY = 0
      local angle = math.rad(selfieMoveOffset + rotZ - 90)
      local drawX2 = centerX + (pointX - centerX) * math.cos(angle) - (pointY - centerY) * math.sin(angle)
      local drawY2 = centerY + (pointX - centerX) * math.sin(angle) + (pointY - centerY) * math.cos(angle)
      local offX, offY, offZ = getPositionFromElementOffset(localPlayer, 0, 0.2, 0.85)
      setCameraMatrix(offX + drawX2, offY + drawY2, offZ + selfieMoveOffsetZ, offX + drawX, offY + drawY, z + 0.55 + selfieOffsetZ, 0, 0)
      if getKeyState("w") and selfieMoveOffsetZ < 0.25 then
        selfieMoveOffsetZ = selfieMoveOffsetZ + 0.01
      elseif getKeyState("s") and 0 < selfieMoveOffsetZ then
        selfieMoveOffsetZ = selfieMoveOffsetZ - 0.01
      end
      if getKeyState("a") and selfieMoveOffset < 20 then
        selfieMoveOffset = selfieMoveOffset + 0.5
      elseif getKeyState("d") and -20 < selfieMoveOffset then
        selfieMoveOffset = selfieMoveOffset - 0.5
      end
    end
  elseif datas[1] == "isSoundOn" then
    if isSoundOn == 1 then
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/on.png")
    else
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/off.png")
    end
  elseif datas[1] == "isVibrateOn" then
    if isVibrateOn == 1 then
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/on.png")
    else
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/off.png")
    end
  elseif datas[1] == "isAdsOn" then
    if isAdsOn == 1 then
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/on.png")
    else
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/off.png")
    end
  elseif datas[1] == "isAdNumberOn" then
    if isAdNumberOn == 1 then
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/on.png")
    else
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/off.png")
    end
  elseif datas[1] == "isNionAdsOn" then
    if isNionAdsOn == 1 then
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/on.png")
    else
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/off.png")
    end
  elseif datas[1] == "isNionAdNumberOn" then
    if isNionAdNumberOn == 1 then
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/on.png")
    else
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), "mobile/off.png")
    end
  elseif datas[1] == "wallpaper" then
    dxDrawImage(x, y, resp(512), resp(512), "mobile/wallpapers/" .. currentWallpaper .. ".png")
  elseif datas[1] == "changemenu" then
    if currentChanging == "wallpaper" then
      dxDrawRectangle(x, y, resp(215), resp(377), tocolor(0, 0, 0, 150))
      dxDrawRectangle(x + resp(10), y + resp(20), resp(215) - resp(20), resp(377) - resp(40))
      dxDrawRectangle(x + resp(10), y + resp(20), resp(215) - resp(20), resp(25) * 13 + resp(1) * 13 + resp(1), tocolor(200, 200, 200, 255))
      for i = 1, 13 do
        dxDrawRectangle(x + resp(10), y + resp(20) + resp(25) * (i - 1) + resp(1) * i, resp(215) - resp(20), resp(25), tocolor(255, 255, 255, 255))
        if i == currentWallpaper then
          dxDrawImage(x + resp(15), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25) / 2 - resp(16) / 2, resp(16), resp(16), "mobile/tick.png")
        else
          dxDrawImage(x + resp(15), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25) / 2 - resp(16) / 2, resp(16), resp(16), "mobile/untick.png")
        end
        dxDrawText("Háttér " .. i, x + resp(20) + resp(16), y + resp(20) + resp(25) * (i - 1) + resp(1) * i, x + resp(10) + resp(215) - resp(20), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25), tocolor(39, 50, 56, 255), 0.8, Roboto, "left", "center")
      end
    elseif currentChanging == "ringtone" then
      dxDrawRectangle(x, y, resp(215), resp(377), tocolor(0, 0, 0, 150))
      dxDrawRectangle(x + resp(10), y + resp(20), resp(215) - resp(20), resp(377) - resp(40))
      dxDrawRectangle(x + resp(10), y + resp(20), resp(215) - resp(20), resp(25) * #ringtones + resp(1) * #ringtones + resp(1), tocolor(200, 200, 200, 255))
      for i = 1, #ringtones do
        dxDrawRectangle(x + resp(10), y + resp(20) + resp(25) * (i - 1) + resp(1) * i, resp(215) - resp(20), resp(25), tocolor(255, 255, 255, 255))
        if i == currentRingtone then
          dxDrawImage(x + resp(15), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25) / 2 - resp(16) / 2, resp(16), resp(16), "mobile/tick.png")
        else
          dxDrawImage(x + resp(15), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25) / 2 - resp(16) / 2, resp(16), resp(16), "mobile/untick.png")
        end
        dxDrawImage(x + resp(10) + resp(215) - resp(20) - resp(16) - resp(5), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25) / 2 - resp(16) / 2, resp(16), resp(16), "mobile/play.png")
        dxDrawText(ringtones[i], x + resp(20) + resp(16), y + resp(20) + resp(25) * (i - 1) + resp(1) * i, x + resp(10) + resp(215) - resp(20), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25), tocolor(39, 50, 56, 255), 0.8, Roboto, "left", "center")
      end
    elseif currentChanging == "notisound" then
      dxDrawRectangle(x, y, resp(215), resp(377), tocolor(0, 0, 0, 150))
      dxDrawRectangle(x + resp(10), y + resp(20), resp(215) - resp(20), resp(377) - resp(40))
      dxDrawRectangle(x + resp(10), y + resp(20), resp(215) - resp(20), resp(25) * #notisounds + resp(1) * #notisounds + resp(1), tocolor(200, 200, 200, 255))
      for i = 1, #notisounds do
        dxDrawRectangle(x + resp(10), y + resp(20) + resp(25) * (i - 1) + resp(1) * i, resp(215) - resp(20), resp(25), tocolor(255, 255, 255, 255))
        if i == currentNotisound then
          dxDrawImage(x + resp(15), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25) / 2 - resp(16) / 2, resp(16), resp(16), "mobile/tick.png")
        else
          dxDrawImage(x + resp(15), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25) / 2 - resp(16) / 2, resp(16), resp(16), "mobile/untick.png")
        end
        dxDrawImage(x + resp(10) + resp(215) - resp(20) - resp(16) - resp(5), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25) / 2 - resp(16) / 2, resp(16), resp(16), "mobile/play.png")
        dxDrawText(notisounds[i], x + resp(20) + resp(16), y + resp(20) + resp(25) * (i - 1) + resp(1) * i, x + resp(10) + resp(215) - resp(20), y + resp(20) + resp(25) * (i - 1) + resp(1) * i + resp(25), tocolor(39, 50, 56, 255), 0.8, Roboto, "left", "center")
      end
    end
  elseif datas[1] == "rectangle" then
    dxDrawRectangle(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), datas[6])
  elseif datas[1] == "dynamictext" then
    dxDrawText(replaceDynamicText(datas[2]), x + resp(datas[3]), y + resp(datas[4]), x + resp(datas[5]), y + resp(datas[6]), datas[7], datas[8], datas[9], datas[10], datas[11], false, true)
  elseif datas[1] == "text" then
    dxDrawText(datas[2], x + resp(datas[3]), y + resp(datas[4]), x + resp(datas[5]), y + resp(datas[6]), datas[7], datas[8], datas[9], datas[10], datas[11])
  elseif datas[1] == "taskbar" then
    drawPhoneComponent(x, y, {
      "rectangle",
      0,
      0,
      215,
      15,
      datas[2]
    })
    drawPhoneComponent(x, y, {
      "dynamictext",
      "#currenttime",
      0,
      0,
      210,
      15,
      tocolor(255, 255, 255),
      0.6,
      Roboto,
      "right",
      "center"
    })
    drawPhoneComponent(x, y, {
      "image",
      -148,
      -69,
      512,
      512,
      "mobile/icons.png"
    })
    local notiPlus = 0
    if 0 < allNewMessages then
      drawPhoneComponent(x, y, {
        "image",
        5,
        1,
        13,
        13,
        "mobile/tasksms.png"
      })
      drawPhoneComponent(x, y, {
        "text",
        allNewMessages,
        21,
        0,
        21,
        15,
        tocolor(255, 255, 255),
        0.6,
        Roboto,
        "left",
        "center"
      })
      notiPlus = 31
    end
    if currentPage ~= "incomingCall" and currentPage ~= "talking" and 0 < missedCalls then
      drawPhoneComponent(x + notiPlus, y, {
        "image",
        5,
        1,
        13,
        13,
        "mobile/taskmissed.png"
      })
      drawPhoneComponent(x + notiPlus, y, {
        "text",
        missedCalls,
        21,
        0,
        21,
        15,
        tocolor(255, 255, 255),
        0.6,
        Roboto,
        "left",
        "center"
      })
    end
  elseif datas[1] == "buttons" then
    drawPhoneComponent(x, y, {
      "rectangle",
      0,
      349,
      215,
      28,
      datas[2]
    })
    drawPhoneComponent(x, y, {
      "image",
      -148,
      -69,
      512,
      512,
      "mobile/buttons.png"
    })
  elseif datas[1] == "talkingLines" then
    local sizeForOne = resp(datas[6] / datas[2])
    for i = 1, datas[2] do
      if talkingLines[i] then
        dxDrawText(talkingLines[i][1], x + resp(datas[3]), y + resp(datas[4]) + sizeForOne * (i - 1), x + resp(datas[5]), y + resp(datas[4]) + sizeForOne * 1, datas[7], datas[8], datas[9], talkingLines[i][2], "center", false, false, false, true)
      end
    end
  elseif datas[1] == "callHistory" then
    local sizeForOne = resp(datas[6]) / datas[2]
    for i = 1, datas[2] do
      if callHistory[i + callHistoryOffset] then
        dxDrawImage(x + resp(datas[3]), y + resp(datas[4]) + sizeForOne * (i - 1) + sizeForOne / 2 - resp(15) / 2, resp(15), resp(15), "mobile/" .. callHistory[i + callHistoryOffset][2] .. ".png")
        dxDrawImage(x + resp(datas[5]) - resp(15), y + resp(datas[4]) + sizeForOne * (i - 1) + sizeForOne / 2 - resp(15) / 2, resp(15), resp(15), "mobile/call.png")
        if reversedContacts[tonumber(callHistory[i + callHistoryOffset][1])] then
          dxDrawText(reversedContacts[tonumber(callHistory[i + callHistoryOffset][1])] .. " (" .. callHistory[i + callHistoryOffset][1] .. ")", x + resp(datas[3]) + resp(20), y + resp(datas[4]) + sizeForOne * (i - 1), x + resp(datas[5]), y + resp(datas[4]) + sizeForOne * i, datas[7], datas[8], datas[9], "left", "center", false, false, false, true)
        else
          dxDrawImage(x + resp(datas[5]) - resp(15) * 2 - resp(5), y + resp(datas[4]) + sizeForOne * (i - 1) + sizeForOne / 2 - resp(15) / 2, resp(15), resp(15), "mobile/add.png", 0, 0, 0, tocolor(1, 200, 83))
          dxDrawText(callHistory[i + callHistoryOffset][1], x + resp(datas[3]) + resp(20), y + resp(datas[4]) + sizeForOne * (i - 1), x + resp(datas[5]), y + resp(datas[4]) + sizeForOne * i, datas[7], datas[8], datas[9], "left", "center", false, false, false, true)
        end
      end
    end
  elseif datas[1] == "smsLines" and messagingWith then
    local currentY = 0
    local height = resp(datas[6])
    if getActiveFakeInput() == datas[10] or 0 < utf8.len(fakeInputValues[datas[10]] or "") then
      height = height - resp(datas[11])
    end
    for i = 1, datas[2] do
      if not messages[messagingWith] then
        messages[messagingWith] = {}
      end
      if messages[messagingWith][i + smsWithOffset] then
        local w = dxGetTextWidth(messages[messagingWith][i + smsWithOffset][1], datas[8], datas[9])
        local num = math.floor(w / (resp(datas[5]) - resp(datas[3] - resp(10))))
        local rw = 0
        if 0 < num then
          rw = resp(datas[5]) - resp(datas[3])
        else
          rw = w + resp(10)
        end
        currentY = currentY + dxGetFontHeight(datas[8], datas[9]) * (num + 1) + resp(5) + resp(10)
        local errColor = false
        if messages[messagingWith][i + smsWithOffset][3] then
          errColor = tocolor(215, 89, 89)
        end
        if height > currentY then
          if messages[messagingWith][i + smsWithOffset][2] == "left" then
            dxDrawRectangle(x + resp(datas[3]), y + resp(datas[4]) + height - currentY, rw, dxGetFontHeight(datas[8], datas[9]) * (num + 1) + resp(10), errColor or tocolor(169, 226, 243, 255))
          else
            dxDrawRectangle(x + resp(datas[5]) - rw, y + resp(datas[4]) + height - currentY, rw, dxGetFontHeight(datas[8], datas[9]) * (num + 1) + resp(10), errColor or tocolor(242, 245, 169, 255))
          end
          dxDrawText(messages[messagingWith][i + smsWithOffset][1], x + resp(datas[3]) + resp(5), y + resp(datas[4]) + height - currentY + resp(5), x + resp(datas[5]) - resp(5), y + resp(datas[4]) + height - currentY + resp(5), datas[7], datas[8], datas[9], messages[messagingWith][i + smsWithOffset][2], "top", false, true)
        else
          break
        end
      end
    end
  elseif datas[1] == "messageUsers" then
    local sizeForOne = resp(datas[6]) / datas[2]
    for i = 1, datas[2] do
      if messageNumbers[i + smsWithChangeOFF] then
        dxDrawImage(x + resp(datas[3]), y + resp(datas[4]) + sizeForOne * (i - 1) + sizeForOne / 2 - resp(30) / 2, resp(30), resp(30), "mobile/user.png")
        local num = messageNumbers[i + smsWithChangeOFF]
        local newMSG = newMessages[num] or 0
        if 0 < newMSG then
          newMSG = " [" .. newMSG .. " új üzenet]"
        else
          newMSG = ""
        end
        if reversedContacts[num] then
          dxDrawText(reversedContacts[num] .. newMSG, x + resp(datas[3]) + resp(35), y + resp(datas[4]) + sizeForOne * (i - 1) + resp(5), x + resp(datas[5]), y + resp(datas[4]) + sizeForOne * i, datas[7], datas[8], datas[9], "left", "top", false, false, false, true)
          dxDrawText(num, x + resp(datas[3]) + resp(35), y + resp(datas[4]) + sizeForOne * (i - 1) + dxGetFontHeight(datas[8], datas[9]) + resp(5), x + resp(datas[5]), y + resp(datas[4]) + sizeForOne * i + dxGetFontHeight(datas[8], datas[9]), datas[7], datas[8] * 0.8, datas[9], "left", "top", false, false, false, true)
        else
          dxDrawText(num .. newMSG, x + resp(datas[3]) + resp(35), y + resp(datas[4]) + sizeForOne * (i - 1) + resp(5), x + resp(datas[5]), y + resp(datas[4]) + sizeForOne * i, datas[7], datas[8], datas[9], "left", "top", false, false, false, true)
        end
      end
    end
  elseif datas[1] == "notifications" then
    local plus = 0
    if 0 < allNewMessages then
      plus = resp(datas[5]) + resp(5)
      dxDrawRectangle(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), datas[6])
      dxDrawImage(x + resp(datas[2]) + resp(5), y + resp(datas[3]) + resp(datas[5]) / 2 - resp(30) / 2, resp(30), resp(30), "mobile/smsicon.png")
      dxDrawText(allNewMessages .. " új üzeneted van!", x + resp(datas[2]) + resp(20) + resp(20), y + resp(datas[3]) + resp(datas[5]) / 2 - resp(30) / 2, x + resp(datas[2]) + resp(20) + resp(20), y + resp(datas[3]) + resp(datas[5]) / 2 - resp(30) / 2 + resp(30), tocolor(0, 0, 0), 0.75, Roboto, "left", "center")
    end
    if 0 < missedCalls then
      dxDrawRectangle(x + resp(datas[2]), y + resp(datas[3]) + plus, resp(datas[4]), resp(datas[5]), datas[6])
      dxDrawImage(x + resp(datas[2]) + resp(5), y + resp(datas[3]) + resp(datas[5]) / 2 - resp(30) / 2 + plus, resp(30), resp(30), "mobile/call.png")
      dxDrawText(missedCalls .. " nem fogadott hívás!", x + resp(datas[2]) + resp(20) + resp(20), y + resp(datas[3]) + resp(datas[5]) / 2 - resp(30) / 2 + plus, x + resp(datas[2]) + resp(20) + resp(20), y + plus + resp(datas[3]) + resp(datas[5]) / 2 - resp(30) / 2 + resp(30), tocolor(0, 0, 0), 0.75, Roboto, "left", "center")
    end
  elseif datas[1] == "image/fakeactive" then
    if getActiveFakeInput() == datas[8] or 0 < utf8.len(fakeInputValues[datas[8]] or "") then
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), datas[7])
    else
      dxDrawImage(x + resp(datas[2]), y + resp(datas[3]), resp(datas[4]), resp(datas[5]), datas[6])
    end
  elseif datas[1] == "contacts" then
    local sizeForOne = resp(datas[6]) / datas[2]
    for i = 1, datas[2] do
      if contacts[i + contactsOffset] then
        dxDrawImage(x + resp(datas[3]), y + resp(datas[4]) + sizeForOne * (i - 1) + sizeForOne / 2 - resp(30) / 2, resp(30), resp(30), "mobile/user.png")
        dxDrawText(contacts[i + contactsOffset][1], x + resp(datas[3]) + resp(35), y + resp(datas[4]) + sizeForOne * (i - 1) + resp(5), x + resp(datas[5]), y + resp(datas[4]) + sizeForOne * i, datas[7], datas[8], datas[9], "left", "top", false, false, false, true)
        dxDrawText(contacts[i + contactsOffset][2], x + resp(datas[3]) + resp(35), y + resp(datas[4]) + sizeForOne * (i - 1) + dxGetFontHeight(datas[8], datas[9]) + resp(5), x + resp(datas[5]), y + resp(datas[4]) + sizeForOne * i + dxGetFontHeight(datas[8], datas[9]), datas[7], datas[8] * 0.8, datas[9], "left", "top", false, false, false, true)
        dxDrawImage(x + resp(datas[5]) - resp(20) * 3 - resp(5) * 2, y + resp(datas[4]) + sizeForOne * (i - 1) + sizeForOne / 2 - resp(20) / 2, resp(20), resp(20), "mobile/delete.png")
        dxDrawImage(x + resp(datas[5]) - resp(20) * 2 - resp(5) * 1, y + resp(datas[4]) + sizeForOne * (i - 1) + sizeForOne / 2 - resp(20) / 2, resp(20), resp(20), "mobile/smsicon.png")
        dxDrawImage(x + resp(datas[5]) - resp(20), y + resp(datas[4]) + sizeForOne * (i - 1) + sizeForOne / 2 - resp(20) / 2, resp(20), resp(20), "mobile/call.png")
      end
    end
  elseif datas[1] == "gameBackground" then
    if currentGame == "mario1" then
      drawPhoneComponent(x, y, {
        "image",
        -148,
        -69,
        512,
        512,
        "mobile/moto-g.png",
        -90
      })
      drawPhoneComponent(x, y, {
        "image",
        -148,
        -69,
        512,
        512,
        "mobile/buttons.png",
        -90
      })
    else
      drawPhoneComponent(x, y, {
        "image",
        -148,
        -69,
        512,
        512,
        "mobile/moto-g.png"
      })
      drawPhoneComponent(x, y, {
        "image",
        -148,
        -69,
        512,
        512,
        "mobile/buttons.png"
      })
    end
  elseif datas[1] == "gameBrowser" then
    if currentGame == "mario1" then
      dxDrawImage(x, y, resp(377), resp(215), gameBrowser)
    else
      dxDrawImage(x, y, resp(215), resp(377), gameBrowser)
    end
    hextrisX, hextrisY = x, y
  end
end
addEventHandler("onClientHUDRender", getRootElement(), function()
  if currentPage == "camera" then
    dxUpdateScreenSource(screenSource, true)
  end
end, true, "high")
function render.phone(x, y)
  if phoneActive then
    if currentPage ~= "camera" and currentPage ~= "game" then
      for i = 1, #phones[usedphone].base.contents do
        if phones[usedphone].base.contents[i] then
          drawPhoneComponent(x + resp(phones[usedphone].base.startpos[1]), y + resp(phones[usedphone].base.startpos[2]), phones[usedphone].base.contents[i])
        end
      end
    end
    for i = 1, #phones[usedphone]["page:" .. currentPage].contents do
      if phones[usedphone]["page:" .. currentPage].contents[i] then
        drawPhoneComponent(x + resp(phones[usedphone]["page:" .. currentPage].startpos[1]), y + resp(phones[usedphone]["page:" .. currentPage].startpos[2]), phones[usedphone]["page:" .. currentPage].contents[i])
      end
    end
    local cx, cy = getCursorPosition()
    activeButton = false
    if cx and cy then
      cx, cy = cx * screenX, cy * screenY
      if phones[usedphone]["page:" .. currentPage].fakeInputs then
        for i = 1, #phones[usedphone]["page:" .. currentPage].fakeInputs do
          local v = phones[usedphone]["page:" .. currentPage].fakeInputs[i]
          local v2 = phones[usedphone]["page:" .. currentPage].startpos
          if v and cx >= resp(v[1]) + x + resp(v2[1]) and cx <= resp(v[3]) + x + resp(v2[1]) and cy >= resp(v[2]) + y + resp(v2[2]) and cy <= resp(v[4]) + y + resp(v2[2]) then
            activeButton = v
          end
        end
      end
      for i = 1, #phones[usedphone]["page:" .. currentPage].buttons do
        local v = phones[usedphone]["page:" .. currentPage].buttons[i]
        local v2 = phones[usedphone]["page:" .. currentPage].startpos
        if v and (string.find(v[5], "changeMenuAction") and currentChanging or not string.find(v[5], "changeMenuAction")) and (string.find(v[5], "changeMenuListen") and currentChanging or not string.find(v[5], "changeMenuListen")) and cx >= resp(v[1]) + x + resp(v2[1]) and cx <= resp(v[3]) + x + resp(v2[1]) and cy >= resp(v[2]) + y + resp(v2[2]) and cy <= resp(v[4]) + y + resp(v2[2]) then
          activeButton = v[5]
        end
      end
    end
  end
end
local callTimer = false
local ringTestSound = false
local reportPhoneNumber = false
function showTheTaxiGui(num)
  reportPhoneNumber = num
  phoneActive = false
  triggerServerEvent("attachMobilePhone", localPlayer, phoneActive)
  if getElementData(localPlayer, "calledTaxi") then
    taxiGuiActive = "calledTaxi"
  else
    taxiGuiActive = true
  end
  if isTimer(callTimer) then
    killTimer(callTimer)
  end
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
end
function showTheMechanicGui(num)
  reportPhoneNumber = num
  phoneActive = false
  triggerServerEvent("attachMobilePhone", localPlayer, phoneActive)
  if getElementData(localPlayer, "calledMechanic") then
    mechanicGuiActive = "calledMechanic"
  else
    mechanicGuiActive = true
  end
  if isTimer(callTimer) then
    killTimer(callTimer)
  end
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
end
function showTheAmbulanceGui(num)
  reportPhoneNumber = num
  phoneActive = false
  triggerServerEvent("attachMobilePhone", localPlayer, phoneActive)
  if getElementData(localPlayer, "calledAmbulance") then
    ambulanceGuiActive = "calledAmbulance"
  else
    ambulanceGuiActive = true
  end
  if isTimer(callTimer) then
    killTimer(callTimer)
  end
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
end
function showTheFiremanGui(num)
  reportPhoneNumber = num
  phoneActive = false
  triggerServerEvent("attachMobilePhone", localPlayer, phoneActive)
  if getElementData(localPlayer, "calledFireman") then
    firemanGuiActive = "calledFireman"
  else
    firemanGuiActive = true
  end
  if isTimer(callTimer) then
    killTimer(callTimer)
  end
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
end
function showThePoliceGui(num)
  reportPhoneNumber = num
  phoneActive = false
  triggerServerEvent("attachMobilePhone", localPlayer, phoneActive)
  if getElementData(localPlayer, "calledPolice") then
    policeGuiActive = "calledPolice"
  else
    policeGuiActive = true
  end
  if isTimer(callTimer) then
    killTimer(callTimer)
  end
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
end
function showTheTowGui(num)
  reportPhoneNumber = num
  phoneActive = false
  triggerServerEvent("attachMobilePhone", localPlayer, phoneActive)
  if getElementData(localPlayer, "calledTow") then
    towGuiActive = "calledTow"
  else
    towGuiActive = true
  end
  if isTimer(callTimer) then
    killTimer(callTimer)
  end
  if isElement(systemSound) then
    destroyElement(systemSound)
  end
end
function noSignal(client)
  if getElementData(client, "isInRio") then
    return true
  end
  local px, py = getElementPosition(client)
  if getDistanceBetweenPoints2D(7255.2490234375, -201.107421875, px, py) < 1150 then
    return true
  end
  return false
end
function dialTheNumber(num, myPhoneNumber)
  sealexports.seal_chat:localActionC(localPlayer, "felhív valakit.")
  if noSignal(localPlayer) then
    triggerEvent("talkingSysMessage", localPlayer, "#d75959*A szolgáltatás jelen pillanatban\n nem elérhető*")
    return
  end
  if tonumber(num) == 104 then
    local players = getElementsByType("player")
    local found = false
    for k = 1, #players do
      if players[k] and sealexports.seal_groups:isPlayerInGroup(players[k], 3) then
        if isTimer(callTimer) then
          killTimer(callTimer)
        end
        callTimer = setTimer(showTheAmbulanceGui, math.random(3000, 6000), 1, myPhoneNumber)
        found = true
        break
      end
    end
    if not found then
      callTimer = setTimer(function()
        if isElement(systemSound) then
          destroyElement(systemSound)
        end
        systemSound = playSound("mobile/sounds/2/mobilebusy.mp3", true)
        triggerEvent("talkingSysMessage", localPlayer, "#d75959*Jelenleg nincs elérhető\nmunkatársunk!*")
      end, math.random(3000, 6000), 1)
    end
  elseif tonumber(num) == 107 then
    local players = getElementsByType("player")
    local found = false
    for k = 1, #players do
      if players[k] and sealexports.seal_groups:isPlayerInGroup(players[k], 1) then
        if isTimer(callTimer) then
          killTimer(callTimer)
        end
        callTimer = setTimer(showThePoliceGui, math.random(3000, 6000), 1, myPhoneNumber)
        found = true
        break
      end
    end
    if not found then
      callTimer = setTimer(function()
        if isElement(systemSound) then
          destroyElement(systemSound)
        end
        systemSound = playSound("mobile/sounds/2/mobilebusy.mp3", true)
        triggerEvent("talkingSysMessage", localPlayer, "#d75959*Jelenleg nincs elérhető\nmunkatársunk!*")
      end, math.random(3000, 6000), 1)
    end
  else
    callTimer = setTimer(triggerServerEvent, math.random(4000, 10000), 1, "callNumber", localPlayer, num, myPhoneNumber)
  end
end
addEventHandler("onClientBrowserCreated", getRootElement(), function()
  if source == gameBrowser then
    loadBrowserURL(gameBrowser, "http://mta/local/mobile/" .. currentGame .. "/index.html")
    focusBrowser(gameBrowser)
  end
end)
function commandHandler(cmd)
  cmd = split(cmd, ":")
  if cmd[1] == "seeNion" then
    if not canUseSeeNion then
      showInfobox("e", "Azonosítás sikertelen!")
    else
      commandHandler("changepage:seeNion")
    end
  elseif cmd[1] == "game" then
    if cmd[2] == "mario" then
      gameBrowser = createBrowser(377, 215, true)
    else
      gameBrowser = createBrowser(215, 377, true)
    end
    currentGame = cmd[2]
    commandHandler("changepage:game")
  elseif cmd[1] == "changepage" then
    if currentPage == "camera" then
      if isElement(screenSource) then
        destroyElement(screenSource)
      end
      if isInSelfieMode then
        setCameraTarget(localPlayer)
        triggerServerEvent("selfieAim", localPlayer, false)
      end
    end
    if currentPage == "game" and isElement(gameBrowser) then
      destroyElement(gameBrowser)
    end
    currentPage = cmd[2]
    incomingButtonDown = false
    activeFakeInput = false
    fakeInputValues = {}
    messagingWith = false
    isInSelfieMode = false
    if currentPage == "camera" then
      screenSource = dxCreateScreenSource(screenSourceX, screenSourceY)
    end
    if cmd[2] == "phone" then
      missedCalls = 0
    end
  elseif cmd[1] == "unLockPhone" then
    commandHandler("changepage:home")
    if isSoundOn == 1 then
      playSound("mobile/sounds/2/mobilelockscreen.mp3")
    end
  elseif cmd[1] == "incomingButtonDown" then
    incomingButtonDown = true
  elseif cmd[1] == "incomingButtonUp" then
    incomingButtonDown = false
  elseif cmd[1] == "takePicture" then
    if not getKeyState("lctrl") then
      local time = getRealTime().timestamp
      local pixels = dxGetTexturePixels(screenSource)
      local pngPixels = dxConvertPixels(pixels, "jpeg")
      local path = "/mobile_photos/" .. time .. ".jpeg"
      if isInSelfieMode then
        path = "/mobile_selfies/" .. time .. ".jpeg"
      end
      local newImg = fileCreate(path)
      fileWrite(newImg, pngPixels)
      fileClose(newImg)
      sealexports.seal_chat:localActionC(localPlayer, "készít egy képet a telefonjával")
      flashScreenRender = true
      startTime = getTickCount()
      if isSoundOn == 1 then
        playSound("mobile/sounds/2/mobilecam.mp3")
      end
    end
  elseif cmd[1] == "selfieMode" then
    isInSelfieMode = not isInSelfieMode
    selfieOffset, selfieOffsetZ = 0, 0
    selfieMoveOffset, selfieMoveOffsetZ = 0, 0
    if not isInSelfieMode then
      setCameraTarget(localPlayer)
      triggerServerEvent("selfieAim", localPlayer, false)
    else
      triggerServerEvent("selfieAim", localPlayer, true)
    end
  elseif cmd[1] == "injectFakeInput" then
    processFakeInput(cmd[2])
  elseif cmd[1] == "dialNumber" then
    if isTimer(callTimer) then
      killTimer(callTimer)
    end
    dialTheNumber(fakeInputValues["page/phone"] or 0, myPhoneNumber)
    talkingText = "Tárcsázás"
    if isElement(systemSound) then
      destroyElement(systemSound)
    end
    systemSound = playSound("mobile/sounds/2/mobilecallsound.mp3", true)
    talkingToNumber = tonumber(fakeInputValues["page/phone"]) or 0
    commandHandler("changepage:talking")
    reversedContacts[talkingToNumber] = false
    if reversedContacts[talkingToNumber] then
      talkerName = reversedContacts[talkingToNumber]
    end
    fakeInputValues = {}
    addCallHistory({talkingToNumber, "outicon"})
  elseif cmd[1] == "acceptCall" then
    triggerServerEvent("acceptCall", localPlayer, callingWith)
    commandHandler("changepage:talking")
    talkingWith = callingWith
    talkingToNumber = callerNumber
    talkerName = false
    for k = 1, #contacts do
      if contacts[k][2] == talkingToNumber then
        talkerName = contacts[k][1]
      end
    end
    callHistory[1][2] = "inicon"
    missedCalls = missedCalls - 1
  elseif cmd[1] == "sendMessage" then
    if isElement(talkingWith) and fakeInputValues.talkingMessage and 0 < utf8.len(fakeInputValues.talkingMessage) then
      local sourceX, sourceY, sourceZ = getElementPosition(localPlayer)
      local vehicleElement = getPedOccupiedVehicle(localPlayer)
      local players = {}
      if vehiclElement and getElementData(vehicleElement, "vehicle.windowState") then
        for k, v in pairs(getVehicleOccupants(vehicleElement)) do
          table.insert(players, {v, "#FFFFFF"})
        end
      else
        for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
          local targetX, targetY, targetZ = getElementPosition(v)
          if getDistanceBetweenPoints3D(sourceX, sourceY, sourceZ, targetX, targetY, targetZ) <= 12 then
            local color = 255
            color = interpolateBetween(255, 255, 255, 50, 50, 50, getDistanceBetweenPoints3D(sourceX, sourceY, sourceZ, targetX, targetY, targetZ) / 12, "Linear")
            table.insert(players, {
              v,
              string.format("#%.2X%.2X%.2X", color, color, color)
            })
          end
        end
      end
      triggerServerEvent("sendPhoneMessage", localPlayer, talkingWith, fakeInputValues.talkingMessage, players)
      addTalkingLine({
        fakeInputValues.talkingMessage,
        "right"
      })
      fakeInputValues.talkingMessage = ""
    end
  elseif cmd[1] == "dialHistory" then
    if callHistory[tonumber(cmd[2]) + callHistoryOffset] then
      if isTimer(callTimer) then
        killTimer(callTimer)
      end
      dialTheNumber(callHistory[tonumber(cmd[2]) + callHistoryOffset][1], myPhoneNumber)
      talkingText = "Tárcsázás"
      if isElement(systemSound) then
        destroyElement(systemSound)
      end
      systemSound = playSound("mobile/sounds/2/mobilecallsound.mp3", true)
      commandHandler("changepage:talking")
      talkingToNumber = callHistory[tonumber(cmd[2]) + callHistoryOffset][1]
      talkerName = false
      for k = 1, #contacts do
        if contacts[k][2] == talkingToNumber then
          talkerName = contacts[k][1]
        end
      end
      addCallHistory({talkingToNumber, "outicon"})
    end
  elseif cmd[1] == "historyToContact" then
    if not callHistory[tonumber(cmd[2])][3] then
      commandHandler("changepage:addcontact")
      activeFakeInput = false
      fakeInputValues = {}
      fakeInputValues.addcontactNum = callHistory[tonumber(cmd[2])][1]
    end
  elseif cmd[1] == "dialContact" then
    if contacts[tonumber(cmd[2]) + contactsOffset] then
      if isTimer(callTimer) then
        killTimer(callTimer)
      end
      dialTheNumber(contacts[tonumber(cmd[2]) + contactsOffset][2], myPhoneNumber)
      talkingText = "Tárcsázás"
      if isElement(systemSound) then
        destroyElement(systemSound)
      end
      systemSound = playSound("mobile/sounds/2/mobilecallsound.mp3", true)
      commandHandler("changepage:talking")
      talkingToNumber = contacts[tonumber(cmd[2]) + contactsOffset][2]
      talkerName = false
      for k = 1, #contacts do
        if contacts[k][2] == talkingToNumber then
          talkerName = contacts[k][1]
        end
      end
      addCallHistory({talkingToNumber, "outicon"})
    end
  elseif cmd[1] == "smsContact" then
    if contacts[tonumber(cmd[2]) + contactsOffset] then
      if not messages[tonumber(contacts[tonumber(cmd[2]) + contactsOffset][2])] then
        table.insert(messageNumbers, tonumber(contacts[tonumber(cmd[2]) + contactsOffset][2]))
        messages[tonumber(contacts[tonumber(cmd[2]) + contactsOffset][2])] = {}
      end
      commandHandler("changepage:messagewith")
      messagingWith = tonumber(contacts[tonumber(cmd[2]) + contactsOffset][2])
      newMessages[messagingWith] = 0
      allNewMessages = 0
      for k, v in pairs(newMessages) do
        allNewMessages = allNewMessages + v
      end
    end
  elseif cmd[1] == "cancelCall" then
    triggerServerEvent("cancelCall", localPlayer, callingWith)
    if isTimer(callTimer) then
      killTimer(callTimer)
    end
    triggerEvent("callEnd", localPlayer)
    if callHistory[1][2] == "missedicon" then
      callHistory[1][2] = "inicon"
      missedCalls = missedCalls - 1
    end
  elseif cmd[1] == "deleteContact" then
    local id = tonumber(cmd[2])
    if contacts[id + contactsOffset] then
      local tmp = {}
      for k = 1, #contacts do
        if contacts[k] and k ~= id + contactsOffset then
          table.insert(tmp, contacts[k])
        end
      end
      contacts = {}
      for k = 1, #tmp do
        contacts[k] = tmp[k]
      end
      reversedContacts = {}
      for k = 1, #contacts do
        if contacts[k] then
          reversedContacts[contacts[k][2]] = contacts[k][1]
        end
      end
    end
  elseif cmd[1] == "messageWith" then
    local id = tonumber(cmd[2])
    if messageNumbers[id + smsWithChangeOFF] then
      commandHandler("changepage:messagewith")
      messagingWith = tonumber(messageNumbers[id + smsWithChangeOFF])
      newMessages[messagingWith] = 0
      allNewMessages = 0
      for k, v in pairs(newMessages) do
        allNewMessages = allNewMessages + v
      end
    end
  elseif cmd[1] == "addcontact" then
    if 0 < utf8.len(fakeInputValues.addcontactName) and 0 < utf8.len(fakeInputValues.addcontactNum) then
      table.insert(contacts, {
        fakeInputValues.addcontactName,
        tonumber(fakeInputValues.addcontactNum)
      })
      reversedContacts = {}
      for k = 1, #contacts do
        if contacts[k] then
          reversedContacts[contacts[k][2]] = contacts[k][1]
        end
      end
      commandHandler("changepage:contacts")
      activeFakeInput = false
      fakeInputValues = {}
    end
  elseif cmd[1] == "startMessaging" then
    if 0 < utf8.len(fakeInputValues["page/startmessaging"]) then
      local messagingNumber = tonumber(fakeInputValues["page/startmessaging"])
      commandHandler("changepage:messagewith")
      if not messages[messageNumbers] then
        table.insert(messageNumbers, messagingNumber)
        messages[messagingNumber] = {}
      end
      messagingWith = messagingNumber
      newMessages[messagingWith] = 0
      allNewMessages = 0
      for k, v in pairs(newMessages) do
        allNewMessages = allNewMessages + v
      end
      fakeInputValues["page/startmessaging"] = ""
    end
  elseif cmd[1] == "sendSMS" then
    if 0 < utf8.len(fakeInputValues.smsMessage) then
      if getTickCount() - (lastSMSSend or 0) >= 5000 then
        triggerServerEvent("sendSMS", localPlayer, messagingWith, myPhoneNumber, fakeInputValues.smsMessage)
        fakeInputValues.smsMessage = ""
        lastSMSSend = getTickCount()
      else
        showInfobox("e", "Ilyen gyorsan nem tudsz üzenetet küldeni!")
      end
    end
  elseif cmd[1] == "calculatorEqual" then
    fakeInputValues["page/calculator"] = fakeInputValues.calculatorEndValue
    fakeInputValues.calculatorEndValue = ""
  elseif cmd[1] == "notificationAction" then
    if 0 < allNewMessages and missedCalls > 0 then
      if tonumber(cmd[2]) == 1 then
        commandHandler("changepage:messages")
      elseif tonumber(cmd[2]) == 2 then
        commandHandler("changepage:phone")
      end
    elseif 0 < allNewMessages and 1 > missedCalls then
      if tonumber(cmd[2]) == 1 then
        commandHandler("changepage:messages")
      end
    elseif missedCalls > 0 and 1 > allNewMessages and tonumber(cmd[2]) == 1 then
      commandHandler("changepage:phone")
    end
  elseif cmd[1] == "changeMenuShow" then
    currentChanging = cmd[2]
  elseif cmd[1] == "changeMenuAction" then
    if currentChanging == "wallpaper" then
      if 1 <= tonumber(cmd[2]) and tonumber(cmd[2]) <= 13 then
        currentWallpaper = tonumber(cmd[2])
        currentChanging = false
      end
    elseif currentChanging == "ringtone" then
      if ringtones[tonumber(cmd[2])] then
        currentRingtone = tonumber(cmd[2])
        currentChanging = false
        if isElement(ringTestSound) then
          destroyElement(ringTestSound)
        end
      end
    elseif currentChanging == "notisound" and notisounds[tonumber(cmd[2])] then
      currentNotisound = tonumber(cmd[2])
      currentChanging = false
      if isElement(ringTestSound) then
        destroyElement(ringTestSound)
      end
    end
  elseif cmd[1] == "changeMenuListen" then
    if currentChanging == "ringtone" then
      local tone = ringtones[tonumber(cmd[2])]
      if isElement(ringTestSound) then
        destroyElement(ringTestSound)
      end
      ringTestSound = playSound("mobile/sounds/ring" .. string.lower(tone) .. ".mp3")
    elseif currentChanging == "notisound" then
      local tone = notisounds[tonumber(cmd[2])]
      if isElement(ringTestSound) then
        destroyElement(ringTestSound)
      end
      ringTestSound = playSound("mobile/sounds/sms" .. string.lower(tone) .. ".mp3")
    end
  elseif cmd[1] == "sendAdvertisement" then
    if fakeInputValues.advertiseMessage and 0 < utf8.len(fakeInputValues.advertiseMessage) then
      if not lastAdvertise or lastAdvertise and math.abs(lastAdvertise - getTickCount()) >= 60000 then
        if isAdNumberOn == 1 then
          triggerServerEvent("sendAdvertisement", localPlayer, fakeInputValues.advertiseMessage, myPhoneNumber)
        else
          triggerServerEvent("sendAdvertisement", localPlayer, fakeInputValues.advertiseMessage, false)
        end
        fakeInputValues.advertiseMessage = ""
        lastAdvertise = getTickCount()
      else
        showInfobox("e", "Csak percenként adhatsz fel hírdetést!")
      end
    end
  elseif cmd[1] == "sendNionAdvertisement" then
    if fakeInputValues.nionAdvertiseMessage and 0 < utf8.len(fakeInputValues.nionAdvertiseMessage) then
      if not lastNionAdvertise or lastNionAdvertise and math.abs(lastNionAdvertise - getTickCount()) >= 60000 then
        if isNionAdNumberOn == 1 then
          triggerServerEvent("sendNionAdvertisement", localPlayer, fakeInputValues.nionAdvertiseMessage, myPhoneNumber)
        else
          triggerServerEvent("sendNionAdvertisement", localPlayer, fakeInputValues.nionAdvertiseMessage, false)
        end
        fakeInputValues.nionAdvertiseMessage = ""
        lastNionAdvertise = getTickCount()
      else
        showInfobox("e", "Csak percenként adhatsz fel hírdetést!")
      end
    end
  elseif cmd[1] == "toggleSoundOn" then
    if isSoundOn == 1 then
      isSoundOn = 0
    else
      isSoundOn = 1
    end
  elseif cmd[1] == "toggleVibrateOn" then
    if isVibrateOn == 1 then
      isVibrateOn = 0
    else
      isVibrateOn = 1
    end
  elseif cmd[1] == "toggleAdsOn" then
    if isAdsOn == 1 then
      isAdsOn = 0
    else
      isAdsOn = 1
    end
  elseif cmd[1] == "toggleAdNumberOn" then
    if isAdNumberOn == 1 then
      isAdNumberOn = 0
    else
      isAdNumberOn = 1
    end
  elseif cmd[1] == "toggleNionAdsOn" then
    if isNionAdsOn == 1 then
      isNionAdsOn = 0
    else
      isNionAdsOn = 1
    end
  elseif cmd[1] == "toggleNionAdNumberOn" then
    if isNionAdNumberOn == 1 then
      isNionAdNumberOn = 0
    else
      isNionAdNumberOn = 1
    end
  end
end
addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY)
  if state == "down" then
    if button == "left" and activeButton and ambulanceGuiActive then
      if activeButton == "yes" then
        triggerServerEvent("callAmbulance", localPlayer, reportPhoneNumber)
        if ambulanceGuiActive == "calledAmbulance" then
          showInfobox("s", "Lemondtad a mentőt!")
        else
          showInfobox("s", "Hívtál egy mentőt!")
        end
        ambulanceGuiActive = false
      elseif activeButton == "no" then
        ambulanceGuiActive = false
      end
      return
    end
    if button == "left" and activeButton and policeGuiActive then
      if activeButton == "yes" then
        triggerServerEvent("callPolice", localPlayer, reportPhoneNumber)
        if policeGuiActive == "calledPolice" then
          showInfobox("s", "Lemondtad a járőrt!")
        else
          showInfobox("s", "Hívtál egy járőrt!")
        end
        policeGuiActive = false
      elseif activeButton == "report" then
        policeReportGuiActive = true
        policeGuiActive = false
        activeButton = false
        activeFakeInput = {
          0,
          0,
          0,
          0,
          "policeReport",
          "normal|100"
        }
      elseif activeButton == "no" then
        policeGuiActive = false
      end
      return
    end
    if button == "left" and activeButton and policeReportGuiActive then
      if activeButton == "yes" then
        if utf8.len(fakeInputValues.policeReport) <= 15 then
          showInfobox("e", "A bejelentés minimum 15 karakteres lehet!")
        else
          triggerServerEvent("reportPolice", localPlayer, reportPhoneNumber, fakeInputValues.policeReport)
          showInfobox("s", "Elküldted a bejelentésed!")
          policeReportGuiActive = false
          activeFakeInput = false
          fakeInputValues.policeReport = ""
        end
      elseif activeButton == "no" then
        policeReportGuiActive = false
        activeFakeInput = false
        fakeInputValues.policeReport = ""
      end
      return
    end
  end
  if button == "left" and phoneActive and currentPage == "game" and not getKeyState("lctrl") then
    local cx, cy = (absoluteX - hextrisX) / responsiveMultipler, (absoluteY - hextrisY) / responsiveMultipler
    injectBrowserMouseMove(gameBrowser, cx, cy)
    if state == "down" then
      injectBrowserMouseDown(gameBrowser, button)
    else
      injectBrowserMouseUp(gameBrowser, button)
    end
  end
  if button == "left" and phoneActive then
    if activeButton then
      if type(activeButton) == "table" then
        if state == "down" then
          activeFakeInput = activeButton
        end
      else
        local datas = split(activeButton, "_")
        local checkState = "down"
        if datas[2] == "[up]" then
          checkState = "up"
        end
        if datas[3] == "[isButtonDown]" and not incomingButtonDown then
          return
        end
        if state == checkState then
          commandHandler(datas[1])
          if not string.find(datas[1], "injectFakeInput") and not string.find(datas[1], "takePicture") and not string.find(datas[1], "unLockPhone") and isSoundOn == 1 then
            playSound("mobile/sounds/2/mobilebuttosnel.mp3")
          end
        end
      end
    elseif state == "down" then
      activeFakeInput = false
    end
  end
end)
function getActiveFakeInput()
  local activeInput = false
  local numOnly = false
  local maxChar = 0
  local nocursor = false
  local calculator = false
  if activeFakeInput then
    local splitted = split(activeFakeInput[6], "|")
    maxChar = tonumber(splitted[2])
    if splitted[1] == "num-only" then
      numOnly = true
    end
    if splitted[1] == "calculator" then
      numOnly = true
      calculator = true
    end
    if splitted[3] == "nocursor" then
      noCursor = true
    end
    activeInput = activeFakeInput[5]
  end
  if phones[usedphone]["page:" .. currentPage].pageFakeInput then
    local splitted = split(phones[usedphone]["page:" .. currentPage].pageFakeInput, "|")
    maxChar = tonumber(splitted[2])
    if splitted[1] == "num-only" then
      numOnly = true
    end
    if splitted[1] == "calculator" then
      numOnly = true
      calculator = true
    end
    if splitted[3] == "nocursor" then
      noCursor = true
    end
    activeInput = "page/" .. currentPage
  end
  return activeInput, numOnly, maxChar, nocursor, calculator
end
function processFakeInput(character)
  local activeFakeInput = false
  local numOnly = false
  local maxChar = 0
  activeFakeInput, numOnly, maxChar, nc, calculator = getActiveFakeInput()
  if activeFakeInput then
    if not fakeInputValues[activeFakeInput] then
      fakeInputValues[activeFakeInput] = ""
    end
    if character == "enter" then
      if activeFakeInput == "talkingMessage" then
        commandHandler("sendMessage")
      elseif activeFakeInput == "smsMessage" then
        commandHandler("sendSMS")
      elseif activeFakeInput == "page/startmessaging" then
        commandHandler("startMessaging")
      elseif activeFakeInput == "page/calculator" then
        commandHandler("calculatorEqual")
      elseif activeFakeInput == "page/phone" then
        commandHandler("dialNumber")
      elseif activeFakeInput == "advertiseMessage" then
        commandHandler("sendAdvertisement")
      end
    elseif character == "backspace" then
      fakeInputValues[activeFakeInput] = utf8.sub(fakeInputValues[activeFakeInput], 0, utf8.len(fakeInputValues[activeFakeInput]) - 1)
    else
      if maxChar > utf8.len(fakeInputValues[activeFakeInput]) then
        if numOnly then
          if calculator then
            if tonumber(character) or character == "+" or character == "." or character == "/" or character == "-" or character == "/" or character == "*" or character == "(" or character == ")" then
              fakeInputValues[activeFakeInput] = fakeInputValues[activeFakeInput] .. character
            end
          elseif tonumber(character) then
            fakeInputValues[activeFakeInput] = fakeInputValues[activeFakeInput] .. character
          end
        else
          fakeInputValues[activeFakeInput] = fakeInputValues[activeFakeInput] .. character
        end
      end
      if isSoundOn == 1 then
        if activeFakeInput == "page/phone" then
          if tonumber(character) == 1 or tonumber(character) == 4 or tonumber(character) == 7 then
            playSound("mobile/sounds/2/mobile147.mp3")
          elseif tonumber(character) == 2 or tonumber(character) == 5 or tonumber(character) == 8 then
            playSound("mobile/sounds/2/mobile258.mp3")
          elseif tonumber(character) == 3 or tonumber(character) == 6 or tonumber(character) == 9 or tonumber(character) == 0 then
            playSound("mobile/sounds/2/mobile369.mp3")
          end
        end
        if activeFakeInput == "page/calculator" then
          playSound("mobile/sounds/2/mobilebuttosnel.mp3")
        end
      end
    end
    if calculator then
    end
  end
end
addEventHandler("onClientCharacter", getRootElement(), processFakeInput)
addEventHandler("onClientKey", getRootElement(), function(key, press)
  local activeInput, numOnly, maxchar, nc, calculator = getActiveFakeInput()
  if activeInput and not numOnly and key ~= "escape" then
    cancelEvent()
  end
  if activeInput and numOnly and (tonumber(key) or key == "lctrl") and key ~= "escape" then
    cancelEvent()
  end
  if activeInput and calculator and (key == "lctrl" or key == "-" or key == "." or key == "/") then
    cancelEvent()
  end
  if currentPage == "contacts" then
    if key == "mouse_wheel_down" then
      contactsOffset = contactsOffset + 1
    elseif key == "mouse_wheel_up" and 0 < contactsOffset then
      contactsOffset = contactsOffset - 1
    end
  end
  if currentPage == "messagewith" then
    if key == "mouse_wheel_up" then
      smsWithOffset = smsWithOffset + 1
    elseif key == "mouse_wheel_down" and 0 < smsWithOffset then
      smsWithOffset = smsWithOffset - 1
    end
  end
  if currentPage == "messages" then
    if key == "mouse_wheel_down" then
      smsWithChangeOFF = smsWithChangeOFF + 1
    elseif key == "mouse_wheel_up" and 0 < smsWithChangeOFF then
      smsWithChangeOFF = smsWithChangeOFF - 1
    end
  end
  if currentPage == "phone" then
    if key == "mouse_wheel_down" then
      callHistoryOffset = callHistoryOffset + 1
    elseif key == "mouse_wheel_up" and 0 < callHistoryOffset then
      callHistoryOffset = callHistoryOffset - 1
    end
  end
  if press then
    if key == "backspace" then
      processFakeInput("backspace")
    end
    if key == "enter" or key == "num_enter" then
      processFakeInput("enter")
    end
  end
end)
