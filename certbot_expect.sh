#!/usr/bin/expect -f

set timeout -1

spawn certbot --nginx --register-unsafely-without-email

expect {
    "No names were found in your configuration files" {
        send "c\n"
        exp_continue
    }
    "blank to select all options shown" {
        send "\n"
        exp_continue
    }
    "Cert not yet due for renewal" {
        exit 0
    }
    "2: Renew & replace the certificate" {
        send "2\n"
        exp_continue
    }
    "Do you agree?" {
        send "Y\n"
        exp_continue
    }
    "Do you want to expand and replace this existing certificate with" {
        send "\n"
        exp_continue
    }
    eof
}
