/****************************************************************************
**
** Copyright (C) 2018 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt 3D Studio Examples.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

/*[[
    <Property name="target" formalName="Target" type="ObjectRef" default="" description="Text element to write the date and time to" />
    <Property name="timeformat" formalName="Time Format" type="String" default="hh:mm:ss" description="Time Formatter" />
    <Property name="locale" formalName="Date and Time Locale" type="String" default="en_EN" description="Date and Time Locale" />
    <Property name="startImmediately" formalName="Start Immediately?" type="Boolean" default="True" publishLevel="Advanced" description="Start immediately, or wait for the Enable action to be called?" />

    <Handler name="start" formalName="Start" category="DateAndTime" description="Start updating" />
    <Handler name="stop" formalName="Stop" category="DateAndTime" description="Stop updating" />
]]*/

import QtStudio3D.Behavior 1.0

Behavior {
    // External
    property string target
    property string timeformat
    property string locale
    property bool startImmediately
    // Internal
    property bool running: false
    property var updateFunction
    property string valueOut
    property var currentDate: new Date()

    function start() {
        running = true;
    }

    function stop() {
        running = false;
    }

    onInitialize: {
        if (startImmediately)
            start();
    }

    onUpdate: {
        if (!running)
            return;

        currentDate = new Date();
        valueOut = currentDate.toLocaleTimeString(Qt.locale(locale), timeformat);//currentDate.toLocaleDateString(Qt.locale(locale)) + "\n "

        setAttribute(target, "textstring", valueOut);
    }
}
