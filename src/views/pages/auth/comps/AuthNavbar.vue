<template>
  <nav class="navbar navbar-expand-lg navbar-dark navbar-laravel">
    <div class="container">
        <a class="navbar-brand" href="#">{{ $t('login.digital_coupon') }}</a>
        <button class="navbar-toggler" type="button"
                data-toggle="collapse"
                data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent"
                aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <router-link :to="{name: 'Login'}"
                                 class="nav-link">
                      {{ $t('login.login') }}</router-link>
                </li>
                <li class="nav-item">
                    <router-link :to="{name: 'Register'}"
                                 class="nav-link">
                      {{ $t('login.register') }}</router-link>
                </li>
            </ul>

        </div>
    </div>
</nav>
</template>
