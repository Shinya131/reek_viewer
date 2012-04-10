# Reek viewer -- reekの出力をHTMLに整形

Step1:
```bash
$ reek -y [dir_or_source_file] > reek.yaml
```
Step2:
```bash
$ ruby reek_viewer.rb ./reek.yaml
```