"""Global Settings"""

## API

# How long until timed-out sessions are cleaned up
SESSION_CLEANUP_DELAY = 30

# How long until sessions time out
SESSION_TIMEOUT_SECONDS = 15

# Valid regions for sessions
VALID_REGIONS = ["AF", "CN", "EA", "EU", "NA", "OC"]

# The maximum size transmitted string fields are allowed to have
SESSION_MAX_STRING_LENGTH = 64

## Login

# How long every single login attempt should take in seconds
LOGIN_ATTEMPT_DELAY = 1

