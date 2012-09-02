{application,okitoki,
             [{description,"Just-in-time chat rooms"},
              {vsn,"1"},
              {registered,[room_sup,usr_sup,usr_namer]},
              {applications,[kernel,stdlib]},
              {mod,{okitoki_app,[]}},
              {env,[]},
              {modules,[client,message_db,okitoki_app,okitoki_sup,room,
                        room_sup,usr,usr_namer,usr_sup]}]}.
