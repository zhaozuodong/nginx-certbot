#!/usr/bin/expect -f

set timeout -1

spawn certbot --nginx --register-unsafely-without-email

expect {
    "Cert not yet due for renewal" {
        send "c"
        exp_continue
    }
    "No names were found in your configuration files" {
        send "c"
        exp_continue
    }
    "Select the appropriate number" {
        send "\n"
        exp_continue
    }
    "2: Renew & replace the certificate" {
        send "2\n"
        exp_continue
    }
    "Do you agree?" {
        send "Y\n"
        exp_continue
    }
    eof
}