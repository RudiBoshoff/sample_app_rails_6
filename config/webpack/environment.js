const { environment } = require('@rails/webpacker')

// In order to make jQuery available in our application, we need to edit Webpack’s 
// environment file and add the content shown in Listing 8.20. - page 465

const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
)

module.exports = environment
