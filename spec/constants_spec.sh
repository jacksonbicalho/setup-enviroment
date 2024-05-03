#shellcheck shell=ksh

Describe 'constants'
    Include lib/constants
    func() {
        # shellcheck disable=SC2034
        constant=$1
    }

    It 'preserves CONFIG_PATH'
        # shellcheck disable=SC2317
        preserve() { %preserve constant; }
        AfterRun preserve

        When run func "$CONFIG_PATH"
        The variable constant should eq "$CONFIG_PATH"
    End

    It 'preserves APP_CONFIG_FILE'
        # shellcheck disable=SC2317
        preserve() { %preserve constant; }
        AfterRun preserve

        When run func "$APP_CONFIG_FILE"
        The variable constant should eq "$APP_CONFIG_FILE"
    End

    It 'preserves LOG_PATH'
        # shellcheck disable=SC2317
        preserve() { %preserve constant; }
        AfterRun preserve

        When run func "$LOG_PATH"
        The variable constant should eq "$LOG_PATH"
    End

    It 'preserves ESSENTIALS'
        # shellcheck disable=SC2317
        preserve() { %preserve constant; }
        AfterRun preserve

        When run func "$ESSENTIALS"
        The variable constant should eq "$ESSENTIALS"
    End

    It 'preserves GIT_HUB_NEW_TOKEN_URL'
        # shellcheck disable=SC2317
        preserve() { %preserve constant; }
        AfterRun preserve

        When run func "$GIT_HUB_NEW_TOKEN_URL"
        The variable constant should eq "$GIT_HUB_NEW_TOKEN_URL"
    End

    It 'preserves ALGORITHMS'
        # shellcheck disable=SC2317
        preserve() { %preserve constant; }
        AfterRun preserve

        When run func "$ALGORITHMS"
        The variable constant should eq "$ALGORITHMS"
    End

    It 'preserves SLEEP'
        # shellcheck disable=SC2317
        preserve() { %preserve constant; }
        AfterRun preserve

        When run func "$SLEEP"
        The variable constant should eq "$SLEEP"
    End

    It 'preserves CONFIGS_INI'
        preserve() { %preserve constant; }
        AfterRun preserve

        When run func "$CONFIGS_INI"
        The variable constant should eq "$CONFIGS_INI"
    End

End
