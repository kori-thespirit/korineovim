# Chuẩn bị
1. Cài đặt phần mềm MQTTX: [Tải phần mềm MQTTX](https://mqttx.app/downloads)
2. Môi trường Linux hoặc Window Subsystem for Linux (WSL) với OpenSSL
3. Đọc và thực hành các bài viết: 
 	- [Giao_tiếp_TLS_SSL_localhost_với_broker](/Tài_liệu_kỹ_thuật/MQTT/Giao_tiếp_TLS_SSL_localhost_với_broker)
 	- [Giao_tiếp_TLS_SSL_client_với_Mosquitto_broker](/Tài_liệu_kỹ_thuật/MQTT/Giao_tiếp_TLS_SSL_client_với_Mosquitto_broker)

# Đặt vấn đề
Để có thể sử dụng phần mềm MQTTX giao tiếp bảo mật TLS/SSL với Mosquitto broker tại port 8883 thì sử dụng chứng chỉ tự ký thông thường x509 của OpenSSL với trường CN (Common Name) là chưa đủ. Yêu cầu kỹ thuật của tiêu chuẩn bảo mật phần mềm hiện nay yêu cầu mở rộng x509 lên version 3 - `x509v3`

Đặc điểm nổi bật của `x509v3` là bổ sung thêm trường `Subject Alternative Name (SAN)` giúp xác minh bảo mật cho nhiều tên miền DNS và các IP khác nhau. Và một chứng chỉ có thể chia sẻ dùng chung giữa các tên miền và máy chủ IP khác nhau

MQTTX yêu cầu trường này tồn tại ở chứng chỉ máy chủ (server) và máy khách (client) để thiết lập kết nối TLS/SSL so với [kết nối TLS/SSL cơ bản](/Tài_liệu_kỹ_thuật/MQTT/Giao_tiếp_TLS_SSL_client_với_Mosquitto_broker)

# Subject Alternative Name (SAN)
Ưu điểm: 
- Cho phép client xác minh máy chủ thông qua địa chỉ IP và tên miền DNS thay vì Common Name
- Một giấy phép có thể được dùng bởi nhiều server và một server có thể có nhiều tên miền. Do đó Common Name(CN) thì không thể chứa hết IP và tên miền khác nhau → SAN giải quyết vấn đề này

Nhược điểm: Yêu cầu kỹ thuật phức tạp hơn để thiết lập tiêu chuẩn bảo mật hiện nay với SAN

Để sử dụng x509v3, lệnh bên dưới sẽ không còn phù hợp:
```
sudo openssl req -new -x509 \
-key /etc/mosquitto/ca_certificates/ca.key \
-out /etc/mosquitto/ca_certificates/ca.crt \
-days 360 \
-subj "/C=VN/ST=ThuDuc/L=HoChiMinh/O=kolabori/CN=kori/emailAddress=korithespirit@gmail.com"
```
Thay vào đó, cần có các tệp cấu hình với đuôi `.cnf` để thiết lập các quy chuẩn mở rộng
# Cấu hình mở rộng x509
Có 4 loại tệp cấu hình với các yêu cầu về quy chuẩn mở rộng khác nhau:
- Dành cho chứng chỉ gốc (RootCA Certificate Extensions) - `rootCA.cnf`
- Dành cho chứng chỉ trung gian (Intermediate Certificate Extensions) - `intermediateCA.cnf`
- Dành cho máy chủ (Server Certificate Extensions) - `server.cnf`
- Dành cho máy khách (Client Certificate Extensions) - `client.cnf`

Ở mức độ cơ bản sẽ không đề cập tới chứng chỉ trung gian (Intermediate Certificate Extensions)
> Chỉ có client tạo ra và sử dụng cấu hình `client.cnf`
{.is-info}

## Yêu cầu cấu hình chứng chỉ gốc - rootCA.cnf
Tham khảo mục Recommended X.509 Extensions for different types of certificates → RootCA Certificate Extensions tại [[1]](https://www.golinuxcloud.com/add-x509-extensions-to-certificate-openssl/) 
Các yêu cầu mở rộng của chứng chỉ gốc bao gồm:
 | Trường mở rộng | Giá trị | Ghi chú
 | ------------- |:-------------:|:-------------:|:-------------:|
 | basicConstraints | critial, CA:TRUE | Trường này bắt buộc xuất hiện<br>Giá trị CA phải là true <br> Trường pathLenConstraint không được xuất hiện
 | subjectKeyIdentifier | hash | 
 | authorityKeyIdentifier | keyid:always,issuer |
 
Cấu hình mẫu RootCA phía server theo bảng trên:
```
kori@server: cat ~/rootCA.cnf
[ req ]
distinguished_name = root_ca_dn
prompt = no
policy = policy_match
x509_extensions = v3_ca

# For the CA policy
[ policy_match ]
countryName             = supplied
stateOrProvinceName     = optional
organizationName        = supplied
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = supplied

[ root_ca_dn ]
C = VN
ST = ThuDuc
L = HoChiMinh
O = kolabori
CN = 14.225.202.16
emailAddress = korithespirit@gmail.com

[ v3_ca ]                     # For self-signed certs; includes CA extensions
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical,CA:TRUE   # Mark as a CA (for self-signed)
keyUsage = critical, keyCertSign, cRLSign
```
Giải thích:
- policy_match: 
- root_ca_dn:
- v3_ca:

## Yêu cầu cấu hình server - server.cnf
Tham khảo mục Recommended X.509 Extensions for different types of certificates → Server Certificate Extensions tại [add-x509-extensions-to-certificate-openssl](https://www.golinuxcloud.com/add-x509-extensions-to-certificate-openssl/) 
| Trường mở rộng              | Giá trị                                                       | Ghi chú |
|------------------------|-------------------------------------------------------------|----------|
| basicConstraints       | CA:FALSE                                                    | The CA field MUST NOT be true. |
| authorityKeyIdentifier | keyid,issuer                                                | This extension MUST be present and MUST NOT be marked critical.<br>It MUST contain a keyIdentifier field and it MUST NOT contain an authorityCertIssuer or authorityCertSerialNumber field. |
| subjectKeyIdentifier   | hash                                                        |  |
| keyUsage               | digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment | keyCertSign and cRLSign MUST NOT be set. |
| extKeyUsage            | serverAuth                                                  | For SSL server certificates.<br>The value anyExtendedKeyUsage MUST NOT be present. |

Cấu hình mẫu cho server:
```
kori@server: cat ~/server.cnf
[ req ]
distinguished_name  = req_distinguished_name
prompt = no
policy              = policy_match
x509_extensions     = user_crt
req_extensions      = v3_req

[v3_req]
basicConstraints = CA:FALSE
subjectAltName = @alt_names  # Reference SANs below
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, codeSigning

[ user_crt ]
nsCertType              = server # avaialbe choice: server, client, email
nsComment               = "OpenSSL Generated Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier  = keyid,issuer

[ req_ext ]
subjectAltName = @alt_names

[ req_distinguished_name ]
C = VN
ST = ThuDuc
L = HoChiMinh
O = kolabori
CN = 14.225.202.16
emailAddress = korithespirit@gmail.com

[ alt_names ]
IP.1 = 14.225.202.16
DNS.1 = www.kolabori.net
DNS.2 = mqtts.kolabori.net
DNS.3 = www.kolabori.vn
DNS.4 = mqtts.kolabori.vn
DNS.5 = www.kolabori.com.vn
DNS.6 = mqtts.kolabori.com.vn
```
Giải thích:
- prompt:
- req_distinguished_name: 
- subjectAltName:
- v3_ca:
- subjectAltName:

 ## Yêu cầu cấu hình client - client.cnf
Tham khảo mục Recommended X.509 Extensions for different types of certificates → Client Certificate Extensions tại [add-x509-extensions-to-certificate-openssl](https://www.golinuxcloud.com//) 
| Trường mở rộng              | Giá trị                                                       | Ghi chú |
|------------------------|-------------------------------------------------------------|----------|
| basicConstraints       | CA:FALSE                                                    | The CA field MUST NOT be true. |
| authorityKeyIdentifier | keyid,issuer                                                | This extension MUST be present and MUST NOT be marked critical.<br>It MUST contain a keyIdentifier field and it MUST NOT contain an authorityCertIssuer or authorityCertSerialNumber field. |
| subjectKeyIdentifier   | hash                                                        |  |
| keyUsage               | digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment | keyCertSign and cRLSign MUST NOT be set. |
| extendedKeyUsage       | clientAuth                                                  | For SSL client certificates.<br>The value anyExtendedKeyUsage MUST NOT be present. |

Cấu hình mẫu cho client:
```
kori@client: cat ~/mqtt/client/client.cnf
[ req ]
distinguished_name  = req_distinguished_name
prompt = no
policy              = policy_match
x509_extensions     = user_crt
req_extensions      = v3_req

[v3_req]
basicConstraints = CA:FALSE
subjectAltName = @alt_names  # Reference SANs below
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = clientAuth

[ user_crt ]
nsCertType              = client # avaialbe choice: server, client, email
nsComment               = "OpenSSL Generated Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier  = keyid,issuer


[ req_distinguished_name ]
C = VN
ST = ThuDuc
L = HoChiMinh
O = kolabori
CN = 14.225.202.16
emailAddress = korithespirit@gmail.com


[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
IP.1 = 14.225.202.16
DNS.1 = www.kolabori.net
DNS.2 = mqtts.kolabori.net
DNS.3 = www.kolabori.vn
DNS.4 = mqtts.kolabori.vn
DNS.5 = www.kolabori.com.vn
DNS.6 = mqtts.kolabori.com.vn
```
# Tạo chứng chỉ tự ký gốc CA và chứng chỉ server từ cấu hình mở rộng x509
## Tạo chứng chỉ tự ký gốc CA
Tạo khóa Certificate Authority (CA) `ca.key`:
```bash
sudo openssl genrsa -out /etc/mosquitto/ca_certificates/ca.key 4096
```
Tạo chứng chỉ tự ký với cấu hình mở rộng `rootCA.cnf` và khóa `ca.key`:
```bash
sudo openssl req \
-new -x509 \
-days 365 \
-config ~/rootCA.cnf \
-key /etc/mosquitto/ca_certificates/ca.key \
-out /etc/mosquitto/ca_certificates/ca.crt
```
## Tạo chứng chỉ server
Tạo khóa server - `server.key`:
```bash
sudo openssl genrsa -out /etc/mosquitto/certs/server.key 4096
```

Tạo yêu cầu ký chứng chỉ server - `server.csr` từ khóa `server.key` và cấu hình mở rộng `server.cnf`:

```bash
sudo openssl req \
-config ~/server.cnf \
-new \
-key /etc/mosquitto/certs/server.key \
-out /etc/mosquitto/certs/server.csr
```
Kiểm tra yêu cầu ký chứng chỉ server:
```
openssl req -text -in /etc/mosquitto/certs/server.csr | grep -A 6 "Requested Extensions:"
```
Kết quả
```
            Requested Extensions:
                X509v3 Basic Constraints:
                    CA:FALSE
                X509v3 Subject Alternative Name:
                    IP Address:14.225.202.16, DNS:www.kolabori.net, DNS:mqtts.kolabori.net, DNS:www.kolabori.vn, DNS:mqtts.kolabori.vn, DNS:www.kolabori.com.vn, DNS:mqtts.kolabori.com.vn
                X509v3 Key Usage:
                    Digital Signature, Non Repudiation, Key Encipherment, Data Encipherment
```
> `Chú ý`: **Extensions in certificates are not transferred to certificate requests and vice versa.**
Ý nghĩa: phần mở rộng x509 (bao gồm SAN) của cấu hình `server.cnf` nằm trong yêu cầu ký chứng chỉ `server.csr` sẽ không tự động đưa sang chứng chỉ server `server.crt` khi dùng `server.csr` để tạo ra `server.crt`
Do đó khi tạo ra `server.crt` cần sử dụng tùy chọn `-extfile` để thêm cấu hình mở rộng `server.cnf`
{.is-warning}

Tạo chứng chỉ server `server.crt` với tùy chọn `-extfile` cho cấu hình mở rộng:
```bash
sudo openssl x509 -req \
-days 365 \
-in /etc/mosquitto/certs/server.csr \
-CA /etc/mosquitto/ca_certificates/ca.crt \
-CAkey /etc/mosquitto/ca_certificates/ca.key \
-CAcreateserial \
-out /etc/mosquitto/certs/server.crt \
-extensions req_ext \
-extfile ~/server.cnf

```
Kiểm tra SAN trong chứng chỉ server:
```
sudo openssl x509 -noout -text -in /etc/mosquitto/certs/server.crt | grep -A 1 "Subject Alternative Name"
```
Kết quả:
```
X509v3 Subject Alternative Name:
                IP Address:14.225.202.16, DNS:www.kolabori.net, DNS:mqtts.kolabori.net, DNS:www.kolabori.vn, DNS:mqtts.kolabori.vn, DNS:www.kolabori.com.vn, DNS:mqtts.kolabori.com.vn
```



# Tạo chứng chỉ máy khách từ cấu hình mở rộng x509
1. Tạo một đường dẫn chứa chứng chỉ:
    ```
    mkdir -p ~/mqtt/client
    ```
2. Thực hiện copy chứng chỉ CA từ máy chủ (server)

    ```bash
    scp <user>@<server-ip-address>:/etc/mosquitto/ca_certificates/ca.crt ~/mqtt/client
    Ex:
    scp kori@14.225.202.16:/etc/mosquitto/ca_certificates/ca.crt ~/mqtt/client
    ```
3. Tạo khóa client - `client.key`:
    ```bash
    sudo openssl genrsa -out ~/mqtt/client/client.key 4096
    ```
4. Tạo yêu cầu ký chứng chỉ (certificate signing request) `client.csr` từ khóa `client.key` và cấu hình mở rộng `client.cnf`:
    ```bash
    sudo openssl req -new \
    -key ~/mqtt/client/client.key \
    -out ~/mqtt/client/client.csr \
    -config ~/mqtt/client/client.cnf
    ```
5. Gửi yêu cầu ký chứng chỉ đến server :
    ```bash
    scp ~/mqtt/client/client.csr <user>@<server-ip-address>:~/
    Ex:
    scp ~/mqtt/client/client.csr kori@14.225.202.16:~/
    ```
    Lý do: bên server giữ khóa CA (`ca.key`) cần thiết để tạo ra chứng chỉ, khóa này không được phép gửi ra khỏi server
6. Bên phía server cần ký để tạo ra chứng chỉ cho client - `client.crt`:
    > Lưu ý cấu hình mở rộng x509 của `client.cnf` không đi kèm theo `client.csr`, do đó server phải đính kèm cấu hình `server.cnf` cho `client.crt`
    {.is-warning}

    ```bash
    # Server side
    sudo openssl x509 -req \
    -days 365 \
    -in ~/client.csr \
    -CA /etc/mosquitto/ca_certificates/ca.crt \
    -CAkey /etc/mosquitto/ca_certificates/ca.key \
    -CAcreateserial \
    -out ~/client.crt \
    -extensions req_ext \
    -extfile ~/server.cnf
    ```
7. Bên phía client copy chứng chỉ `client.crt` từ server về máy để phục vụ xác thực:
    ```bash
    # Client side
    scp <user>@<server-ip-address>:/etc/mosquitto/ca_certificates/client.crt ~/mqtt/client/
    Ex:
    scp kori@14.225.202.16:~/client.crt ~/mqtt/client/
    ```

8. Khóa client.key cần đổi chủ sở hữu sang $USER hiện tại đang login vào để MQTTX có thể đọc được khóa
    ```bash
    # Client side
    sudo chown $USER:$USER ~/mqtt/client/client.key
    ```
    
    
## Thiết lập quyền truy cập các chứng chỉ

Các khóa (.key) không được phép truy cập bởi Mosquitto, chỉ được thao tác đọc ghi bởi người dùng root do đó truy cập ở quyền 600:

```bash
# Only root can read and edit the key
sudo chmod 600 /etc/mosquitto/certs/server.key
sudo chmod 600 /etc/mosquitto/ca_certificates/ca.key
```

Các chứng chỉ (.crt) chỉ được phép đọc, không được thay đổi bởi Mosquitto và client:

```bash
# Local user and client guest access to certificate have only read permisson
sudo chmod 644 /etc/mosquitto/certs/server.crt
sudo chmod 644 /etc/mosquitto/ca_certificates/ca.crt
```

Trao quyền thao tác cho Mosquitto:

```bash
sudo chmod 755 certs/
# Change ownership from root to mosquitto due to mosquitto
# need to access files in certs folder
sudo chown mosquitto:mosquitto /etc/mosquitto/certs/
```

Kết quả cần đạt:

```bash
ls -al /etc/mosquitto/certs
-rw-r--r-- 1 mosquitto mosquitto 1980 Apr 12 14:17 server.crt
-rw-r--r-- 1 mosquitto mosquitto 1740 Apr 12 14:13 server.csr
-rw------- 1 mosquitto mosquitto 3272 Apr 12 13:47 server.key

ls -al /etc/mosquitto/ca_certificates/
-rw-r--r-- 1 root root 2090 Apr 12 17:40 ca.crt
-rw------- 1 root root 3272 Apr 12 13:59 ca.key
-rw-r--r-- 1 root root   41 Apr 12 22:40 ca.srl

ls -al /etc/mosquitto/mosquitto.conf
-rw-r--r-- 1 mosquitto mosquitto 842 Apr 12 22:43 /etc/mosquitto/mosquitto.conf
```
# Cấu hình cho Mosquitto

Tham khảo tài liệu chính thức: [https://mosquitto.org/man/mosquitto-conf-5.html](https://mosquitto.org/man/mosquitto-conf-5.html)

```bash
sudoedit /etc/mosquitto/mosquitto.conf
```

Thêm nội dung bên dưới:

```plaintext
# Place your local configuration in /etc/mosquitto/conf.d/
#
# A full description of the configuration file is at
# /usr/share/doc/mosquitto/examples/mosquitto.conf.example

pid_file /run/mosquitto/mosquitto.pid

# Store mosquitto broker state in a persistent location
persistence true
persistence_location /var/lib/mosquitto/

# Log destination path
log_dest file /var/log/mosquitto/mosquitto.log

# Configuration directory
include_dir /etc/mosquitto/conf.d

# Not use password login if certificate method is used
# password_file /etc/mosquitto/passwd

# Allow non-user access to broker
allow_anonymous true

# Listening at port 1883 without certificate
listener 1883 0.0.0.0

# Specify listener (MQTTs over TCP)
listener 8883 0.0.0.0
cafile /etc/mosquitto/ca_certificates/ca.crt
certfile /etc/mosquitto/certs/server.crt
keyfile /etc/mosquitto/certs/server.key
# Require client certificate, set to false if not provide client cert
require_certificate true

# Use CN field in client certificate to authenticate valid user if set to true
use_identity_as_username false
```

Giải thích:

- require_certificate true - Bắt buộc phía client phải gửi chứng chỉ đi kèm
- Lắng nghe tại port 1883 không yêu cầu chứng chỉ:
`listener 1883 0.0.0.0`
- Lắng nghe tại port 8883 với các chứng chỉ server đi kèm:
`listener 8883 0.0.0.0`
`cafile /etc/mosquitto/ca_certificates/ca.crt`
`certfile /etc/mosquitto/certs/server.crt`
`keyfile /etc/mosquitto/certs/server.key`
- Cho phép máy khách (client) chưa đăng ký vẫn có thể sử dụng được broker
`allow_anonymous true`

Yêu cầu Mosquitto sử dụng cấu hình:

```bash
mosquitto -c /etc/mosquitto/mosquitto.conf -d
```

Sau khi chỉnh sửa cần khởi động lại broker:

```bash
sudo service mosquitto restart
```
# Script tạo chứng chỉ CA và server - generate_server_crt.sh
```bash
#! /bin/bash

CAKEY_PATH=~/
SERVER_CERT_PATH=~/

sudo openssl genrsa -out $CAKEY_PATH/ca.key 4096
sudo openssl genrsa -out $SERVER_CERT_PATH/server.key 4096
sudo openssl req \
  -new \
  -x509 \
  -days 365 \
  -config $CAKEY_PATH/rootCA.cnf \
  -key $CAKEY_PATH/ca.key \
  -out $CAKEY_PATH/ca.crt
sudo openssl req \
  -new \
  -key $SERVER_CERT_PATH/server.key \
  -out $SERVER_CERT_PATH/server.csr \
  -config $SERVER_CERT_PATH/server.cnf
sudo openssl req -text -in $SERVER_CERT_PATH/server.csr | grep -A 6 "Requested Extensions:"
sudo openssl x509 -req \
  -days 365 \
  -in $SERVER_CERT_PATH/server.csr \
  -CA $CAKEY_PATH/ca.crt \
  -CAkey $CAKEY_PATH/ca.key \
  -CAcreateserial \
  -out $SERVER_CERT_PATH/server.crt \
  -extfile $SERVER_CERT_PATH/server.cnf \
  -extensions req_ext
```


# Script tạo yêu cầu ký chứng chỉ client - generate_client_csr.sh
```bash
#! /bin/bash

MQTT_CLIENT_PATH=~/mqtt/client
VPS_IP_ADDR="14.225.202.16"
USER_GROUP=$USER # staff with MacOS

mkdir -p $MQTT_CLIENT_PATH
scp kori@$VPS_IP_ADDR:/etc/mosquitto/ca_certificates/ca.crt $MQTT_CLIENT_PATH
sudo openssl genrsa -out $MQTT_CLIENT_PATH/client.key 4096
# MQTTX need permission to read client.key, if owner is root, MQTTX has no permission to read this key
sudo chown $USER:$USER_GROUP $MQTT_CLIENT_PATH/client.key

sudo openssl req -new \
  -key $MQTT_CLIENT_PATH/client.key \
  -out $MQTT_CLIENT_PATH/client.csr \
  -config $MQTT_CLIENT_PATH/client.cnf

openssl req -text -in $MQTT_CLIENT_PATH/client.csr | grep -A 6 "Requested Extensions:"
scp $MQTT_CLIENT_PATH/client.csr kori@$VPS_IP_ADDR:~/
```
# Script tạo chứng chỉ client trên server - generate_client_crt.sh
```bash
#! /bin/bash

CAKEY_PATH=~/
SERVER_CERT_PATH=~/
CLIENT_PATH=~/
rm client.crt

sudo openssl x509 -req \
  -days 365 \
  -in $CLIENT_PATH/client.csr \
  -CA /etc/mosquitto/ca_certificates/ca.crt \
  -CAkey /etc/mosquitto/ca_certificates/ca.key \
  -CAcreateserial \
  -out $CLIENT_PATH/client.crt \
  -extensions req_ext \
  -extfile $SERVER_CERT_PATH/server.cnf
```
# Script copy chứng chỉ client về máy client - get_client_crt_from_server.sh
```bash
#! /bin/bash

MQTT_CLIENT_PATH=~/mqtt/client
VPS_IP_ADDR="14.225.202.16"
scp kori@$VPS_IP_ADDR:~/client.crt $MQTT_CLIENT_PATH
```

# Kết nối TLS/SSL MQTT bằng phần mềm MQTTX

