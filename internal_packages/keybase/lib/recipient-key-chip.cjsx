{MessageStore, React} = require 'nylas-exports'
PGPKeyStore = require './pgp-key-store'
pgp = require 'kbpgp'
_ = require 'underscore'

# Sits next to recipient chips in the composer and turns them green/red
# depending on whether or not there's a PGP key present for that user
class RecipientKeyChip extends React.Component

  @displayName: 'RecipientKeyChip'

  @propTypes:
    contact: React.PropTypes.object.isRequired

  constructor: (props) ->
    super(props)
    @state = @_getStateFromStores()

  componentDidMount: ->
    @unlistenKeystore = PGPKeyStore.listen(@_onKeystoreChange, @)

  componentWillUnmount: ->
    @unlistenKeystore()

  _getStateFromStores: ->
    return {
      # true if there is at least one loaded key for the account
      keys: PGPKeyStore.pubKeys(@props.contact.email).some((cv, ind, arr) =>
          cv.hasOwnProperty('key')
        )
    }

  _onKeystoreChange: ->
    @setState(@_getStateFromStores())

  render: ->
    if @state.keys
      <div className="n1-keybase-recipient-key-chip">
        <span ref="keyIcon">KEY&nbsp;&nbsp;</span>
      </div>
    else
      <div className="n1-keybase-recipient-key-chip">
        <span ref="noKeyIcon"></span>
      </div>


module.exports = RecipientKeyChip
