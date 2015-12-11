Package.describe({
  name: 'codefabric:meteor-shopify-ui-table',
  version: '0.1.0',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  api.use(['ecmascript', 
           'coffeescript',
           'templating',
           'less',
           'mongo',
           'underscore',
           'session',
           'tracker',
           'themeteorchef:jquery-validation@1.14.0',
           'fortawesome:fontawesome@4.4.0',
           'codefabric:meteor-common@0.1.0',
           'codefabric:meteor-shopify@0.1.0']);

  api.imply('codefabric:meteor-common');
  api.imply('codefabric:meteor-shopify');

  // *** Standard CodeFabric Structure *** //

  api.addFiles([
    'global_namespaces.js',
    'lib/namespaces.coffee',
  ], ['client', 'server']);

  api.addFiles([
    'client/namespaces.coffee'
  ], ['client']);

  api.addFiles([
    'server/namespaces.coffee'
  ], ['server']);

  // *** Package Files *** //

  api.addFiles([
    'client/lib/shopifyTableColumn.coffee',
    'client/lib/shopifyTableItem.coffee',
    'client/lib/shopifyTable.coffee',
    'client/lib/helpers.coffee',

    'client/views/shopifyItemAdd.html',
    'client/views/shopifyItemAdd.coffee',
    'client/views/shopifyItemEdit.html',
    'client/views/shopifyItemEdit.coffee',
    'client/views/shopifyItemDisplay.html',
    'client/views/shopifyItemDisplay.coffee',
    'client/views/shopifyTableHeader.html',
    'client/views/shopifyTableHeader.coffee',
    'client/views/shopifyTable.html',
    'client/views/shopifyTable.coffee',

    'client/styles/shopifyTable.less',

  ], ['client'])
});

// Package.onTest(function(api) {
//   api.use('ecmascript');
//   api.use('coffeescript');
//   api.use('tinytest');
//   api.use('codefabric:meteor-shopify-ui-table');

//   api.addFiles('tests/client/tests.coffee', 'client');
//   api.addFiles('tests/server/tests.coffee', 'server');
// });
