{% from "pam-ldap/map.jinja" import pam_ldap with context %}

{% if salt['pillar.get']('pam:tls_cacertfile') %}
tls_cacertfile:
  file.managed:
    - source: salt://pam-ldap/files/cert
    - user: root
    - group: root
    - mode: 640
{% endif %}

pam-ldap:
  pkg.installed:
    - name: {{ pam_ldap.pkg }}

{{ pam_ldap.config }}:
  file.managed:
    - source: salt://pam-ldap/files/ldap.conf
    - user: {{ salt['pillar.get']('pam:ldap:user', 'root')  }}
    - group: {{ salt['pillar.get']('pam:ldap:group', 'root')  }}
    - mode: 644

ldap_conf:
  file.append:
    - name: /etc/ldap.conf
    - text:
        - host {{ salt['pillar.get']('pam:ldap:host') }}
        {% if salt['pillar.get']('pam:ldap:port') %}
        - port {{ salt['pillar.get']('pam:ldap:port') }}
        {% endif %}
        - base {{ salt['pillar.get']('pam:ldap:base') }}
        - ldap_version {{ salt['pillar.get']('pam:ldap:version', 3) }}
        - bind_policy {{ salt['pillar.get']('pam:ldap:policy') }}
        {% if salt['pillar.get']('pam:ldap:binddn') %}
        - binddn {{ salt['pillar.get']('pam:ldap:binddn', '') }}
        - bindpw {{ salt['pillar.get']('pam:ldap:bindpw', '') }}
        {% endif %}
        - scope {{ salt['pillar.get']('pam:ldap:scope', 'sub') }}
        {% if salt['pillar.get']('pam:ldap:pam_lookup_policy') %}
        - pam_lookup_policy {{ salt['pillar.get']('pam:ldap:pam_lookup_policy', 'yes') }}
        {% endif %}
        {% if salt['pillar.get']('pam:ldap:pam_groupdn') %}
        - pam_groupdn {{ salt['pillar.get']('pam:ldap:pam_groupdn') }}
        {% endif %}
        {% if salt['pillar.get']('pam:ldap:pam_member_attribute') %}
        - pam_member_attribute {{ salt['pillar.get']('pam:ldap:pam_member_attribute', 'member') }}
        {% endif %}
        {% if salt['pillar.get']('pam:ldap:pam_password') %}
        - pam_password {{ salt['pillar.get']('pam:ldap:pam_password') }}
        {% endif %}
        {% if salt['pillar.get']('pam:ldap:ssl') %}
        - ssl {{ salt['pillar.get']('pam:ldap:ssl') }}
        {% endif %}
        {% if salt['pillar.get']('pam:ldap:tls_checkpeer') == 'yes' %}
        - tls_checkpeer {{ salt['pillar.get']('pam:ldap:tls_checkpeer', 'no') }}
        - tls_cacertfile {{ salt['pillar.get']('pam:ldap:tls_cacertfile', '') }}
        - tls_cacertdir {{ salt['pillar.get']('pam:ldap:tls_cacertdir', '') }}
        {% endif %}
