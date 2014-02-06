# B generator

Maintainer: [Miguel Cardoso](https://github.com/Thr44)

A Backbone generator forked from Revath S Kumar https://github.com/yeoman/generator-backbone, with some extra components originally developed by http://www.aerstudio.com/ and extended by thr44

by default it uses Handlebars framework

Rather use backbone-generator from Yeoman Team!!




## Usage

Install: `sudo npm install -g generator-bestiario`

Make a new directory and `cd` into it:
```
mkdir my-new-project && cd $_
```

Run `yo bestiario`, optionally passing an app name:
```
yo bestiario [app-name]
```


## Generators

Available generators:

- bestiario:model
- bestiario:view
- bestiario:element-view
- bestiario:d3-view
- bestiario:collection-view
- bestiario:view
- bestiario:collection
- bestiario:router
- bestiario:all

## Typical workflow

```
yo bestiario # generates your application base and build workflow
yo bestiario:model blog
yo bestiario:collection blog
yo bestiario:router blog
yo bestiario:view blog
yo bestiario:element-view blog
yo bestiario:d3-view blog
yo bestiario:collection-view blog
grunt serve
```


## License

[BSD license](http://opensource.org/licenses/bsd-license.php)
