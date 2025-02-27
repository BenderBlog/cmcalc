package io.github.benderblog.cmcalc

import CalendarExecuteState
import CalendarSystemFromDart
import CalendarWrapper
import com.jherkenhoff.libqalculate.CalendarSystem
import com.jherkenhoff.libqalculate.QalculateDateTime
import com.jherkenhoff.libqalculate.ReturnedChineseYearInfo
import com.jherkenhoff.libqalculate.ReturnedDate
import com.jherkenhoff.libqalculate.libqalculate.calendarToDate
import com.jherkenhoff.libqalculate.libqalculate.chineseCycleYearToYear
import com.jherkenhoff.libqalculate.libqalculate.chineseYearInfoToAndroid
import com.jherkenhoff.libqalculate.libqalculate.dateToCalendarToAndroid
import com.jherkenhoff.libqalculate.libqalculate.numberOfMonths
import com.jherkenhoff.libqalculate.libqalculateConstants.NUMBER_OF_CALENDARS

class CalendarBridge : CalendarWrapper {
    var date: QalculateDateTime = QalculateDateTime()
    var block_calendar_conversion  : Boolean = false

    init {
        date.setToCurrentDate()
    }


    private fun translateSystemFromKotlin(ct:CalendarSystem): CalendarSystemFromDart {
        return when (ct) {
            CalendarSystem.CALENDAR_MILANKOVIC-> {
                CalendarSystemFromDart.MILANKOVIC
            }

            CalendarSystem.CALENDAR_JULIAN-> {
                CalendarSystemFromDart.JULIAN
            }

            CalendarSystem.CALENDAR_ISLAMIC-> {
                CalendarSystemFromDart.ISLAMIC
            }

            CalendarSystem.CALENDAR_HEBREW -> {
                CalendarSystemFromDart.HEBREW
            }

            CalendarSystem.CALENDAR_EGYPTIAN -> {
                CalendarSystemFromDart.EGYPTIAN
            }

            CalendarSystem.CALENDAR_PERSIAN -> {
                CalendarSystemFromDart.PERSIAN
            }

            CalendarSystem.CALENDAR_COPTIC -> {
                CalendarSystemFromDart.COPTIC
            }

            CalendarSystem.CALENDAR_ETHIOPIAN -> {
                CalendarSystemFromDart.ETHIOPIAN
            }

            CalendarSystem.CALENDAR_INDIAN -> {
                CalendarSystemFromDart.INDIAN
            }

            CalendarSystem.CALENDAR_CHINESE -> {
                CalendarSystemFromDart.CHINESE
            }

            else -> {
                CalendarSystemFromDart.GREGORIAN
            }
        }
    }

    private fun translateSystemFromDart(ct:CalendarSystemFromDart): CalendarSystem {
        return when (ct) {
            CalendarSystemFromDart.MILANKOVIC-> {
                CalendarSystem.CALENDAR_MILANKOVIC
            }

            CalendarSystemFromDart.JULIAN -> {
                CalendarSystem.CALENDAR_JULIAN
            }

            CalendarSystemFromDart.ISLAMIC -> {
                CalendarSystem.CALENDAR_ISLAMIC
            }

            CalendarSystemFromDart.HEBREW -> {
                CalendarSystem.CALENDAR_HEBREW
            }

            CalendarSystemFromDart.EGYPTIAN -> {
                CalendarSystem.CALENDAR_EGYPTIAN
            }

            CalendarSystemFromDart.PERSIAN -> {
                CalendarSystem.CALENDAR_PERSIAN
            }

            CalendarSystemFromDart.COPTIC -> {
                CalendarSystem.CALENDAR_COPTIC
            }

            CalendarSystemFromDart.ETHIOPIAN -> {
                CalendarSystem.CALENDAR_ETHIOPIAN
            }

            CalendarSystemFromDart.INDIAN -> {
                CalendarSystem.CALENDAR_INDIAN
            }

            CalendarSystemFromDart.CHINESE -> {
                CalendarSystem.CALENDAR_CHINESE
            }

            else -> {
                CalendarSystem.CALENDAR_GREGORIAN
            }
        }
    }

    override fun setCalendar(
        yearStem: Long?,
        year: Long,
        month: Long,
        day: Long,
        calendarSystem: CalendarSystemFromDart,
        callback: (Result<CalendarExecuteState>) -> Unit
    ) {
        if (block_calendar_conversion) {
            callback(Result.success(CalendarExecuteState(
                    isSuccess = false,
                    message = "Conversion ongoing.",
                    data = mapOf(),
                )))
            return
        }
        block_calendar_conversion = true

        var y : Int = year.toInt()
        if (calendarSystem == CalendarSystemFromDart.CHINESE) {
            if (yearStem == null) {
                callback(
                    Result.success(
                        CalendarExecuteState(
                            isSuccess = false,
                            message = "Input Chinese Calendar but no stem year detected.",
                            data = mapOf(),
                        )
                    )
                )
                block_calendar_conversion = false
                return
            }

            if (yearStem <= 0) {
                callback(
                    Result.success(
                        CalendarExecuteState(
                            isSuccess = false,
                            message = "The selected Chinese year does not exist.",
                            data = mapOf(),
                        )
                    )
                )
                block_calendar_conversion = false
                return
            }

            y = chineseCycleYearToYear(79, yearStem.toInt())
        }

        if(!calendarToDate(date,
                y,
                month.toInt(),
                day.toInt(),
                translateSystemFromDart(calendarSystem)
                )) {
            callback(
                Result.success(
                    CalendarExecuteState(
                        isSuccess = false,
                        message = "Conversion to Gregorian calendar failed.",
                        data = mapOf(),
                    )
                )
            )
            block_calendar_conversion = false
            return
        }

        lateinit var cs : CalendarSystem
        val toReturn : MutableMap<CalendarSystemFromDart, List<Any?>> = mutableMapOf()
        for(i : Int in 0..NUMBER_OF_CALENDARS - 1) {
            when(i) {
                0 -> {cs = CalendarSystem.CALENDAR_GREGORIAN }
                 1 -> {cs = CalendarSystem.CALENDAR_HEBREW }
                 2 -> {cs = CalendarSystem.CALENDAR_ISLAMIC }
                 3 -> {cs = CalendarSystem.CALENDAR_PERSIAN}
                 4 -> {cs = CalendarSystem. CALENDAR_INDIAN}
                 5 -> {cs = CalendarSystem.CALENDAR_CHINESE}
                 6 -> {cs = CalendarSystem.CALENDAR_JULIAN}
                 7 -> {cs = CalendarSystem.CALENDAR_MILANKOVIC}
                 8 -> {cs = CalendarSystem.CALENDAR_COPTIC}
                 9 -> {cs = CalendarSystem.CALENDAR_ETHIOPIAN}
                 10 -> {cs = CalendarSystem.CALENDAR_EGYPTIAN}
            }
            val toReturnStringList : MutableList<String> = mutableListOf()

            val result : ReturnedDate = dateToCalendarToAndroid(date, y, month.toInt(), day.toInt(), cs)

            if(result.isSuccess && month <= numberOfMonths(cs) && day <= 31) {
                if(cs == CalendarSystem.CALENDAR_CHINESE) {
                    val data : ReturnedChineseYearInfo = chineseYearInfoToAndroid(result.year)

                    toReturnStringList +="${(data.stem - 1) / 2}"
                    toReturnStringList += "${data.branch - 1}"
                } else {
                    toReturnStringList += "${result.year}"
                }
                toReturnStringList += "${result.month - 1}"
                toReturnStringList += "${result.day - 1}"
            }
            toReturn[translateSystemFromKotlin(cs)] = toReturnStringList.toList()
        }
        callback(
            Result.success(
                CalendarExecuteState(
                    isSuccess = true,
                    message = "",
                    data = toReturn.toMap(),
                )
            )
        )
        block_calendar_conversion = false
        return
    }
}