import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'

import AppLayout from '@/views/layouts/AppLayout.vue'
import Dashboard from '@/views/pages/Dashboard.vue'
import Widgets from '@/views/pages/Widgets.vue'
import LayoutOptions from '@/views/pages/LayoutOptions.vue'
import Charts from '@/views/pages/Charts.vue'
import UIElements from '@/views/pages/UIElements.vue'
import Forms from '@/views/pages/Forms.vue'
import Tables from '@/views/pages/Tables.vue'

// Layout Options
import TopNavigation from '@/views/pages/layoutOptions/TopNavigation.vue'
import TopNavigationSidebar from '@/views/pages/layoutOptions/TopNavigationSidebar.vue'
import Boxed from '@/views/pages/layoutOptions/Boxed.vue'
import FixedSidebar from '@/views/pages/layoutOptions/FixedSidebar.vue'
import FixedNavbar from '@/views/pages/layoutOptions/FixedNavbar.vue'
import FixedFooter from '@/views/pages/layoutOptions/FixedFooter.vue'
import CollapsedSidebar from '@/views/pages/layoutOptions/CollapsedSidebar.vue'

Vue.use(VueRouter)

const routes = [
	{
		path: '/',
		name: 'Home',
		component: Home
	},
	{
		path: '/app',
		name: 'App',
		component: AppLayout,
		children: [
			{
				path: '/dashboard',
				name: 'dashboard',
				component: Dashboard
			},
			{
				path: '/widgets',
				name: 'widgets',
				component: Widgets
			},
			{
				path: '/layout_options',
				name: 'layout_options',
				component: LayoutOptions
			},
			{
				path: '/charts',
				name: 'charts',
				component: Charts
			},
			{
				path: '/ui_elements',
				name: 'ui_elements',
				component: UIElements
			},
			{
				path: '/forms',
				name: 'forms',
				component: Forms
			},
			{
				path: '/tables',
				name: 'tables',
				component: Tables
			},
			{
				path: '/top_navigation',
				name: 'top_navigation',
				component: TopNavigation
			},
			{
				path: '/top_navigation_sidebar',
				name: 'top_navigation_sidebar',
				component: TopNavigationSidebar
			},
			{
				path: '/boxed',
				name: 'boxed',
				component: Boxed
			},
			{
				path: '/fixed_sidebar',
				name: 'fixed_sidebar',
				component: FixedSidebar
			},
			{
				path: '/fixed_navbar',
				name: 'fixed_navbar',
				component: FixedNavbar
			},
			{
				path: '/fixed_footer',
				name: 'fixed_footer',
				component: FixedFooter
			},
			{
				path: '/collapsed_sidebar',
				name: 'collapsed_sidebar',
				component: CollapsedSidebar
			},
			{
				path: '/top_navigation',
				name: 'top_navigation',
				component: TopNavigation
			},
			{
				path: '/top_navigation',
				name: 'top_navigation',
				component: TopNavigation
			},
			{
				path: '/top_navigation',
				name: 'top_navigation',
				component: TopNavigation
			},

		]
	},
	{
		path: '/about',
		name: 'About',
		// route level code-splitting
		// this generates a separate chunk (about.[hash].js) for this route
		// which is lazy-loaded when the route is visited.
		component: () => import(/* webpackChunkName: "about" */ '../views/About.vue')
	}
]

const router = new VueRouter({
	mode: 'history',
	base: process.env.BASE_URL,
	routes
})

export default router
