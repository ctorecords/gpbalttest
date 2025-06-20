use Test::More;
use lib::abs 'lib';
use uni::perl ':dumper';
use GPBExim::TestHelper qw(test_live_search_in_parsed_logfile);

test_live_search_in_parsed_logfile('Поиск после разбора длинного предоставленного файла по подстроке' => lib::abs::path('../temp/maillog'), {
        'fwxvparobkymnbyemevz@london.com' => {
            search => {
                render=> 'JSON',
                data => [
                    { int_id => "1QIIgl-000F1c-JL", o_id => 3662, t => "log", created => "2012-02-13 14:49:31", str => '1QIIgl-000F1c-JL ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded' },
                    { int_id => "1QIKLq-000KB4-DB", o_id => 3058, t => "log", created => "2012-02-13 14:49:16", str => '1QIKLq-000KB4-DB ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded' },
                    { int_id => "1QN0p8-000MTa-JW", o_id => 3690, t => "log", created => "2012-02-13 14:49:31", str => '1QN0p8-000MTa-JW ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded' },
                    { int_id => "1QTLsC-000LHz-VW", o_id => 3660, t => "log", created => "2012-02-13 14:49:31", str => '1QTLsC-000LHz-VW ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded' },
                    { int_id => "1QTXe4-0006SI-7A", o_id => 4397, t => "log", created => "2012-02-13 14:49:48", str => '1QTXe4-0006SI-7A ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded' },
                    { int_id => "1QTYLU-000Nic-SN", o_id => 3073, t => "log", created => "2012-02-13 14:49:16", str => "1QTYLU-000Nic-SN ** fwxvparobkymnbyemevz\@london.com: retry timeout exceeded",
                        # признак, что список превысил лимит
                        continue => 1,
                    }
                ]
            },
        },

        'aoyfuviev@yandex.ru' => {
            search => {
                render=> 'JSON',
                data => [
                    { int_id => "1Rwtd1-0000Ac-QT", o_id => 6670, t => "log", created => "2012-02-13 14:59:36", str => '1Rwtd1-0000Ac-QT == aoyfuviev@yandex.ru R=dnslookup T=remote_smtp defer (-1): domain matches queue_smtp_domains, or -odqs set' },
                    { int_id => "1Rwtd1-0000Ac-QT", o_id => 7672, t => "log", created => "2012-02-13 15:00:21", str => '1Rwtd1-0000Ac-QT => aoyfuviev@yandex.ru R=dnslookup T=remote_smtp H=mx.yandex.ru [87.250.250.89]* C="250 2.0.0 Ok: queued on mxfront35.mail.yandex.net as 0J4u9PaF-0J4WuG2S"' },
                    { int_id => "1Rwtd1-0000Ac-Ry", o_id => 6672, t => "log", created => "2012-02-13 14:59:36", str => '1Rwtd1-0000Ac-Ry == aoyfuviev@yandex.ru R=dnslookup T=remote_smtp defer (-1): domain matches queue_smtp_domains, or -odqs set' },
                    { int_id => "1Rwtd1-0000Ac-Ry", o_id => 7665, t => "log", created => "2012-02-13 15:00:20", str => '1Rwtd1-0000Ac-Ry => aoyfuviev@yandex.ru R=dnslookup T=remote_smtp H=mx.yandex.ru [213.180.193.89]* C="250 2.0.0 Ok: queued on mxfront9h.mail.yandex.net as 0Ifi5sND-0Jf4Eebf"' },
                    { int_id => "1Rwtd2-0000Ac-LK", o_id => 6692, t => "log", created => "2012-02-13 14:59:36", str => '1Rwtd2-0000Ac-LK == aoyfuviev@yandex.ru R=dnslookup T=remote_smtp defer (-1): domain matches queue_smtp_domains, or -odqs set' },
                    { int_id => "1Rwtd2-0000Ac-LK", o_id => 7643, t => "log", created => "2012-02-13 15:00:19", str => '1Rwtd2-0000Ac-LK => aoyfuviev@yandex.ru R=dnslookup T=remote_smtp H=mx.yandex.ru [93.158.134.89]* C="250 2.0.0 Ok: queued on mxfront19.mail.yandex.net as 0910LsKP-0J1CJpnN"' },
                ]
            },
        },
        'london' => {
            search => {
                render=> 'JSON',
                data => [
                    { int_id => "1QIIgl-000F1c-JL", o_id => 3661, t => "log", created => "2012-02-13 14:49:31", str => '1QIIgl-000F1c-JL == udbbwscdnbegrmloghuf@london.com R=dnslookup T=remote_smtp defer (-44): SMTP error from remote mail server after RCPT TO:<udbbwscdnbegrmloghuf@london.com>: host mx0.gmx.com [74.208.5.90]: 450 4.3.2 Too many mails (mail bomb), try again in 1 hour(s) 14 minute(s) and see ( http://portal.gmx.net/serverrules ) {mx-us003}' },
                    { int_id => "1QIIgl-000F1c-JL", o_id => 3662, t => "log", created => "2012-02-13 14:49:31", str => '1QIIgl-000F1c-JL ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded' },
                    { int_id => "1QIKLq-000KB4-DB", o_id => 3056, t => "log", created => "2012-02-13 14:49:16", str => '1QIKLq-000KB4-DB == udbbwscdnbegrmloghuf@london.com R=dnslookup T=remote_smtp defer (-44): SMTP error from remote mail server after RCPT TO:<udbbwscdnbegrmloghuf@london.com>: host mx0.gmx.com [74.208.5.90]: 450 4.3.2 Too many mails (mail bomb), try again in 1 hour(s) 15 minute(s) and see ( http://portal.gmx.net/serverrules ) {mx-us015}' },
                    { int_id => "1QIKLq-000KB4-DB", o_id => 3058, t => "log", created => "2012-02-13 14:49:16", str => '1QIKLq-000KB4-DB ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded' },
                    { int_id => "1QN0p8-000MTa-JW", o_id => 3689, t => "log", created => "2012-02-13 14:49:31", str => '1QN0p8-000MTa-JW == udbbwscdnbegrmloghuf@london.com R=dnslookup T=remote_smtp defer (-44): SMTP error from remote mail server after RCPT TO:<udbbwscdnbegrmloghuf@london.com>: host mx0.gmx.com [74.208.5.90]: 450 4.3.2 Too many mails (mail bomb), try again in 1 hour(s) 14 minute(s) and see ( http://portal.gmx.net/serverrules ) {mx-us009}' },
                    { int_id => "1QN0p8-000MTa-JW", o_id => 3690, t => "log", created => "2012-02-13 14:49:31", str => '1QN0p8-000MTa-JW ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded',
                        # признак, что список превысил лимит
                        continue => 1,
                    }
                ]
            },
            suggest => {
                data => [
                    { address => "fwxvparobkymnbyemevz\@london.com" },
                    { address => "udbbwscdnbegrmloghuf\@london.com" },
                ],
                render => "JSON"
            },
        },
    },
    ui__server_host => '0.0.0.0',
    ui__silent => 1,
    ui__max_results => 6,
);

done_testing;