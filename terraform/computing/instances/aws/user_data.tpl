#cloud-config
ssh_authorized_keys:
  {% for key in ssh_keys.split("\n") %}
  - "{{ key }}"
  {% endfor %}
