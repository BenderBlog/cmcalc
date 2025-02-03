// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: GPL-2.0-or-later

package io.github.benderblog.cmcalc

import CalcResult
import CalculatorWrapper
import com.jherkenhoff.libqalculate.Calculator
import com.jherkenhoff.libqalculate.MessageType

// Suppose to be "always running"
class CalculatorBridge(val calc: Calculator) : CalculatorWrapper {
    init {
        calc.loadGlobalDefinitions()
    }

    private fun parseCommand(command: String) : String {
        val toParse = calc.parse(command)
        toParse.format()
        return toParse.print()
    }

    override fun calculate(command: String, callback: (Result<CalcResult>) -> Unit) {
        calc.clearMessages()

        val result = calc.calculate(calc.unlocalizeExpression(command))
        val message = calc.message()

        val resultMsg : CalcResult = CalcResult(
            resultType = if (message == null) {
                ResultType.SUCCESS
            } else {
                when (message.type()) {
                    MessageType.MESSAGE_ERROR -> ResultType.FAILURE
                    MessageType.MESSAGE_WARNING ->ResultType.WARNING
                    else -> ResultType.SUCCESS
                }
            },
            message = if (message == null) {
                ""
            } else {
                message.message()
            },
            parsed = parseCommand(command),
            result = result.print(),
        )
        callback(Result.success(resultMsg))
    }

    override fun parseCommand(command: String, callback: (Result<String>) -> Unit) {
        callback(Result.success(parseCommand(command)))
    }
}