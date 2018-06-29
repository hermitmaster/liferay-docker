package org.hermitmaster.specification

import geb.spock.GebSpec
import spock.lang.Ignore

class LoginSpec extends GebSpec {
    def setup() {

    }

    def cleanup() {

    }

    def "TestLogin"() {
        when:
        go "/c/portal/login"
        $("input[name\$='login']").value('test')
        $("input[name\$='password']").value('test')
        $('.btn-primary').click()

        then:
        true
    }
}
