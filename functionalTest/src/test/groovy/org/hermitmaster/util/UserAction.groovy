package org.hermitmaster.util

import geb.Browser

class UserAction {
    static void login() {
        Browser.drive {
            go "/c/portal/login"
        }
    }

    static void logout() {

    }
}
