Aplicação criada para automatizar o processo de gerar builds de modulos Flutter para Aplicações nativas. Ponto de entrada do código se econtra no diretório `bin/`, e as blibliotecas no `lib/`.

Para rodar esta aplicação, primeiramente faça o setup dos seus projetos no arquivo  `lib/flutter_module_projects.dart`, posteriormente use o comando `dart run`. 

## Fazendo o setup

Para realizar o setup é simples, apenas deve ser colocado o caminho dos aplicativos nativos e do módulo flutter. Exemplo:

```dart
final flutterModuleProjects = [
  Project(
    projectName: 'meu-super-projeto',
    iosPath: '/Users/meu-usuario/Desktop/super-projetos/meu-super-projeto-ios',
    androidPath: '/Users/meu-usuario/Desktop/super-projetos/meu-super-projeto-android',
    flutterPath: '/Users/meu-usuario/Desktop/super-projetos/meu-super-projeto-flutter',
  ),
   Project(
    projectName: 'meu-super-projeto-2',
    iosPath: '/Users/meu-usuario/Desktop/super-projetos/meu-super-projeto-2-ios',
    androidPath: '/Users/meu-usuario/Desktop/super-projetos/meu-super-projeto-2-android',
    flutterPath: '/Users/meu-usuario/Desktop/super-projetos/meu-super-projeto-2-flutter',
  ),
];
```
