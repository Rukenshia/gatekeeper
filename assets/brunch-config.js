exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/app.js": /^(?!js\/pages)/,
        "js/team.js": /^(node_modules|js\/pages\/team)/,
        "js/approver_selection.js": /^(node_modules|js\/pages\/approver_selection)/,
      },

      // To use a separate vendor.js bundle, specify two files path
      // http://brunch.io/docs/config#-files-
      // joinTo: {
      //   "js/app.js": /^js/,
      //   "js/vendor.js": /^(?!js)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // order: {
      //   before: [
      //     "vendor/js/jquery-2.1.1.js",
      //     "vendor/js/bootstrap.min.js"
      //   ]
      // }
    },
    stylesheets: {
      joinTo: "css/app.css"
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/],
      presets: [['env', {
        "targets": {
          "browsers": ["last 2 versions"],
        },
      }], 'stage-0'],
      plugins: ['transform-es2015-modules-commonjs'],
    },
    sass: {
      mode: "native",
      options: {
        includePaths: ['node_modules'],
      }
    },
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"],
      "js/team.js": ["js/pages/team"],
      "js/approver_selection.js": ["js/pages/approver_selection"],
    }
  },

  npm: {
    enabled: true,
    compilers: ['babel-brunch'],
  }
};
