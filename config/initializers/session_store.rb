Rails.application.config.session_store :active_record_store, key: (Rails.env.production? ? '_genesys_session_id' : (Rails.env.demo? ? '_genesys_demo_session_id' : '_genesys_dev_session_id')),
                                                             secure: (Rails.env.demo? || Rails.env.production?),
                                                             httponly: true
