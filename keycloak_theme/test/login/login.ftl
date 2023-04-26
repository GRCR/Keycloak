<#import "template.ftl" as layout>
    <@layout.registrationLayout
        displayMessage=!messagesPerField.existsError('username','password')
        displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
        <#if section="header">
            <!-- ${msg("loginAccountTitle")} -->
            
            <#elseif section="form">
                <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
                    <div class="flex flex-col items-center">
                        <a href="#" class="flex items-center text-2xl font-semibold text-blue-700">
                            <img class="w-6 h-6 mr-2" src="https://flowbite.s3.amazonaws.com/blocks/marketing-ui/logo.svg" alt="logo" />
                           <span class="uppercase"> ${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc} </span>
                        </a>
                        <div class="mb-8 mt-0 font-bold text-lg">Integrated Education....</div>
                    </div>
                    <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-lg xl:p-0 dark:bg-gray-800 dark:border-gray-700">
                        <div class="flex items-center justify-between w-full bg-blue-700 h-12 rounded-t-lg">
                            <div class="flex items-center">
                                <a href="#"
                                    class="flex items-center text-2xl font-semibold text-blue-700 dark:text-white ">
                                    <img class="w-8 h-8 ml-6" src="https://flowbite.s3.amazonaws.com/blocks/marketing-ui/logo.svg" alt="logo" />
                                    <span class="text-base text-white ml-2 uppercase"> ${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc} </span>
                                </a>
                            </div>
                            <div class="flex items-start">
                                <#if realm.internationalizationEnabled && locale.supported?size gt 1>
                                    <div class="${properties.kcLocaleMainClass!}" id="kc-locale">
                                        <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                                            <div id="kc-locale-dropdown" class="dropdown  hover:bg-blue-800 hover:rounded-lg mr-1 inline-block relative">
                                                <a href="#" id="kc-current-locale-link" class="text-white font-semibold py-2 px-4 inline-flex items-center">
                                                    <#--  ${msg("changeLanguageTitle")}:--> ${locale.current}  
                                                    <svg class="w-4 h-4 ml-2" aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                                    </svg>
                                                </a>
                                                <div class="dropdown-menu absolute hidden z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700">
                                                    <ul class="py-2 text-sm text-gray-700 dark:text-gray-200">
                                                        <#list locale.supported as l>
                                                            <li class="${properties.kcLocaleListItemClass!}">
                                                                <a class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white" href="${l.url}">
                                                                    ${l.label}
                                                                </a>
                                                            </li>
                                                        </#list>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </#if>
                            </div>
                        </div>
                        <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                            <h1 class="text-lg mb-3 font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
                                Sign in to <span class="uppercase"> ${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc} </span>
                            </h1>
                            <#if realm.password>
                                <form id="kc-form-login" class="space-y-4 md:space-y-6" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                                    <#if !usernameHidden??>
                                        <div>
                                            <label for="username" class="${properties.kcLabelClass!}">
                                                <#if !realm.loginWithEmailAllowed>
                                                    ${msg("username")}
                                                    <#elseif !realm.registrationEmailAsUsername>
                                                        ${msg("usernameOrEmail")}
                                                        <#else>
                                                            ${msg("email")}
                                                </#if><span class="text-red-600">*</span>
                                            </label>
                                            <input tabindex="1" id="username" class="${properties.kcInputClass!}" name="username" placeholder="Enter account name here" value="${(login.username!'')}" type="text" autofocus autocomplete="off"
                                                aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
                                            <#if messagesPerField.existsError('username','password')>
                                                <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                                </span>
                                            </#if>
                                        </div>
                                    </#if>
                                    <div>
                                        <label for="password" class="${properties.kcLabelClass!}">
                                            ${msg("password")}
                                            <span class="text-red-600">*</span></label>
                                        <input tabindex="2" id="password" class="${properties.kcInputClass!}" name="password" placeholder="Enter password" type="password" autocomplete="off"
                                            aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
                                        <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                                            <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                                ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                            </span>
                                        </#if>
                                    </div>
                                    <div class="${properties.kcFormGroupClass!} ${properties.kcFormSettingClass!}">
                                        <div id="kc-form-options">
                                            <#if realm.rememberMe && !usernameHidden??>
                                                <div class="checkbox">
                                                    <label>
                                                        <#if login.rememberMe??>
                                                            <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" checked>
                                                            ${msg("rememberMe")}
                                                            <#else>
                                                                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox">
                                                                ${msg("rememberMe")}
                                                        </#if>
                                                    </label>
                                                </div>
                                            </#if>
                                        </div>
                                    </div>
                                    <div class="flex items-center justify-between mt-3">
                                        <div id="kc-form-buttons" class="flex items-start">
                                            <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"
                            </#if>/>
                            <input tabindex="4" name="login" id="kc-login" type="submit" value="${msg("doLogIn")}" class="${properties.kcSubmitClass}" />
                        </div>
                        <#if realm.resetPasswordAllowed>
                            <span><a tabindex="5" class="${properties.kcForgotPasswordClass!}" href="${url.loginResetCredentialsUrl}">
                                    ${msg("doForgotPassword")}
                                </a></span>
                        </#if>
                    </div>
                    </form>
        </#if>
        </div>
        </div>
        <div class="flex items-start justify-between p-5 sm:max-w-lg">
            <div class="flex items-start flex-col w-1/2">
                <div class="font-bold">Get IEIMS ID</div>
                <div class="text-sm">
                    If you don't have an IEIMS ID number then you can apply for your
                    IEIMS ID number.
                </div>
                <a href="#"
                    class="${properties.kcRegistratrionClass!}">Apply
                    for IEIMS ID</a>
            </div>
            <div class="flex items-start flex-col">
                <div class="font-bold">Create Public Account</div>
                <div class="text-sm">If you are not and ...</div>
                <a href="#"
                    class="${properties.kcRegistratrionClass!}">Create
                    Public Account</a>
            </div>
        </div>
        </div>
        <#elseif section="info">
            <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
                <div id="kc-registration-container">
                    <div id="kc-registration">
                        <span>
                            ${msg("noAccount")}
                            <a tabindex="6"
                                href="${url.registrationUrl}">
                                ${msg("doRegister")}
                            </a></span>
                    </div>
                </div>
            </#if>
            <#elseif section="socialProviders">
                <#if realm.password && social.providers??>
                    <div id="kc-social-providers" class="${properties.kcFormSocialAccountSectionClass!}">
                        <hr />
                        <h4>
                            ${msg("identity-provider-login-label")}
                        </h4>
                        <ul class="${properties.kcFormSocialAccountListClass!}
<#if social.providers?size gt 3>
${properties.kcFormSocialAccountListGridClass!}
</#if>">
                            <#list social.providers as p>
                                <a id="social-${p.alias}" class="${properties.kcFormSocialAccountListButtonClass!}
<#if social.providers?size gt 3>
${properties.kcFormSocialAccountGridItem!}
</#if>"
                                    type="button" href="${p.loginUrl}">
                                    <#if p.iconClasses?has_content>
                                        <i class="${properties.kcCommonLogoIdP!} ${p.iconClasses!}" aria-hidden="true"></i>
                                        <span class="${properties.kcFormSocialAccountNameClass!} kc-social-icon-text">
                                            ${p.displayName!}
                                        </span>
                                        <#else>
                                            <span class="${properties.kcFormSocialAccountNameClass!}">
                                                ${p.displayName!}
                                            </span>
                                    </#if>
                                </a>
                            </#list>
                        </ul>
                    </div>
                </#if>
                </#if>
    </@layout.registrationLayout>