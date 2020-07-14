[Unit]
Description=clockwork
After=syslog.target network.target

[Service]
Type=notify
WatchdogSec=10
WorkingDirectory=/var/www/torntrader/config
ExecStart=/bin/bash -lc 'exec /home/torntrader/.rbenv/shims/clockwork clockwork.rb'
User=torntrader
Group=torntrader
UMask=0002

Environment=MALLOC_ARENA_MAX=2

# if we crash, restart
RestartSec=1
Restart=on-failure

StandardOutput=syslog
StandardError=syslog

SyslogIdentifier=clockwork

[Install]
WantedBy=multi-user.target